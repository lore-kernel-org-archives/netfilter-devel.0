From: Jean Weisbuch <jean@phpnet.org>
Subject: Re: [ulog2 PATCH] Non-arbitrary malloc for SQL queries + string
 length limit
Date: Mon, 2 Oct 2017 18:32:26 +0200
Message-ID: <8c1d5fdd-4e64-36e6-148b-559b9202ce9c@phpnet.org>
References: <bcadb7a2-d429-af84-e871-167da12e0819@phpnet.org>
 <nycvar.YFH.7.76.1709220841540.12548@n3.vanv.qr>
 <025be696-ba9b-ad63-96cb-0db137acd3c9@phpnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from taillefer.phpnet.org ([194.110.192.54]:49906 "EHLO
        taillefer.phpnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751082AbdJBQc2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2017 12:32:28 -0400
Received: from mailfilter2.phpnet.org (mailfilter2.phpnet.org [195.144.11.141])
        by taillefer.phpnet.org (Postfix) with SMTP id AE65371006A9
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2017 18:32:26 +0200 (CEST)
Received: from rt-bur1.phpnet.org ([195.144.11.241] helo=[192.168.1.145])
        by smtp.phpnet.org with esmtpa (Exim 4.80)
        (envelope-from <jean@phpnet.org>)
        id 1dz3dq-0005Yn-Jk
        for netfilter-devel@vger.kernel.org; Mon, 02 Oct 2017 18:32:26 +0200
In-Reply-To: <025be696-ba9b-ad63-96cb-0db137acd3c9@phpnet.org>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 02/10/2017 à 14:54, Jean Weisbuch a écrit :
> Le 22/09/2017 à 08:44, Jan Engelhardt a écrit :
>
>> On Thursday 2017-09-21 19:00, Jean Weisbuch wrote:
>>>    - For strings, SQL_STRINGSIZE now defines the max length of 
>>> values (before
>>> being escaped), longer values will be truncated and the double of
>>> SQL_STRINGSIZE is allocated in case all characters would have to be 
>>> escaped
>>>
>>> I am not sure that truncating values is the best course of action, 
>>> maybe
>>> replacing the string with NULL or an empty string would be better?
>> Silent truncation is really bad. If the currenty query length can be 
>> externally
>> influenced (and I have no doubt that it can), you may end up executing a
>> different statement than what was intended.
>>
>> Return an error code from the function, abort() the entire program, or
>> something. But don't silently truncate.
>
> Here is a revised patch that does set the value to NULL instead of 
> truncating it.
>
> I dont know how to cleanly abort the query generation if its what 
> would be prefered.
>
> [...]

Just found a bug with my patch : ulogd_key_size() returns -1 if the key 
type is not on its list and it happens with the output keys of the 
IP2BIN filter plugin that are all of ULOGD_RET_RAWSTR (0x8040) type 
which is not listed on the ulogd_key_size() function.

As the ULOGD_RET_RAWSTR type is listed in __format_query_db() but not on 
ulogd_key_size() : No memory is allocated for the value on the statement 
but its still added to it.


Setting an arbitrary key length (SQL_STRINGSIZE or maybe the old default 
value of 100 chars?) for unknown keys would be the simplest fix.
A cleaner solution would be to simply raise a fatal error to avoid any 
risks but it might break plugins that use return key type not listed on 
ulogd_key_size() and that were working previously.
It might also be possible to disable the key like if it have the 
ULOGD_KEYF_INACTIVE flag but i dont think that its the right solution.

As for the specific case of the missing ULOGD_RET_RAWSTR type on 
ulogd_key_size(), it seems to be only used on IP2BIN which will always 
return a 34 char long value, some possible solutions :

  * Make ulogd_key_size() return a length of 16 for the RAWSTR type as
    for the IP6ADDR type which would result in allocating 40 chars
  * Add on sql_createstmt() "elseif(key->type == ULOGD_RET_RAWSTR) {
    size += 35; }"
  * Use the ULOGD_RET_IP6ADDR type which seems unused ; it would also
    need to be added to the __format_query_db switch()

The first 2 solution might be problematic if RAWSTR is used by other 
plugins to store lengthier informations.


Another issue is that "ulogd --info ulogd_filter_IP2BIN.so" does list 
all the output values as of "Unknown type", its because the type is 
missing from the type_to_string() function on ulogd.c.


Here is a revised patch of db.c that does set the key_length to 
SQL_STRINGSIZE for unknown key types :

--- util/db.c	2014-03-23 16:30:50.000000000 +0100
+++ util/db.c	2017-10-02 18:09:02.069746918 +0200
@@ -57,7 +57,8 @@
  }
  
  #define SQL_INSERTTEMPL   "SELECT P(Y)"
-#define SQL_VALSIZE	100
+/* Maximum string length (non-escaped), will be replaced with NULL if longer */
+#define SQL_STRINGSIZE	255
  
  /* create the static part of our insert statement */
  static int sql_createstmt(struct ulogd_pluginstance *upi)
@@ -78,13 +79,35 @@
  	for (i = 0; i < upi->input.num_keys; i++) {
  		if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
  			continue;
+
+		struct ulogd_key *key = upi->input.keys[i].u.source;
+		short key_length = 4;
+
  		/* we need space for the key and a comma, as well as
-		 * enough space for the values */
-		size += strlen(upi->input.keys[i].name) + 1 + SQL_VALSIZE;
+		 * enough space for the values (and quotes around strings) */
+		if(key->type == ULOGD_RET_STRING) {
+			/* SQL_STRINGSIZE is the max (VAR)CHAR length, *2 in case every of its characters would be escaped and +3 for the quotes around the string and the comma at the end */
+			ulogd_log(ULOGD_DEBUG, "allocating %d bytes for string %s of type %s", (SQL_STRINGSIZE * 2) + 3, key->name, type_to_string(key->type));
+			size += (SQL_STRINGSIZE * 2) + 3;
+		} else {
+			/* key_length is the maximum strlen for the specified integer type (ex: ULOGD_RET_INT32 lowest value is -2147483648 which is 11 characters long) */
+			key_length = ulogd_key_size(key);
+			if(key_length < 1) {
+				/* ulogd_key_size() returns -1 for key types it does not know */
+				key_length = SQL_STRINGSIZE;
+				ulogd_log(ULOGD_ERROR, "%s key length cannot be determined, forced to %hd bytes", upi->input.keys[i].name, key_length);
+			} else {
+				key_length = 10*key_length*8/33+2;
+			}
+			ulogd_log(ULOGD_DEBUG, "allocating %hd bytes for int %s of type %s", key_length, upi->input.keys[i].name, type_to_string(key->type));
+
+			/* +1 for the comma at the end */
+			size += key_length + 1;
+		}
  	}
  	size += strlen(procedure);
  
-	ulogd_log(ULOGD_DEBUG, "allocating %u bytes for statement\n", size);
+	ulogd_log(ULOGD_DEBUG, "allocating a total of %u bytes for the statement\n", size);
  
  	mi->stmt = (char *) malloc(size);
  	if (!mi->stmt) {
@@ -373,14 +396,20 @@
  			sprintf(stmt_ins, "'%d',", res->u.value.b);
  			break;
  		case ULOGD_RET_STRING:
-			*(stmt_ins++) = '\'';
  			if (res->u.value.ptr) {
-				stmt_ins +=
-				di->driver->escape_string(upi, stmt_ins,
-							  res->u.value.ptr,
-							strlen(res->u.value.ptr));
+				if(strlen(res->u.value.ptr) > SQL_STRINGSIZE) {
+					ulogd_log(ULOGD_ERROR, "The string for the key %s is too long (>%d chars), value is set to NULL", upi->input.keys[i].name, SQL_STRINGSIZE);
+					stmt_ins += sprintf(stmt_ins, "NULL,");
+				} else {
+					/* the string is escaped and put between quotes */
+					*(stmt_ins++) = '\'';
+					stmt_ins += di->driver->escape_string(upi, stmt_ins, res->u.value.ptr, strlen(res->u.value.ptr));
+					stmt_ins += sprintf(stmt_ins, "\',");
+				}
+			} else {
+				ulogd_log(ULOGD_NOTICE, "No string passed for the key %s, setting the value to NULL", upi->input.keys[i].name);
+				stmt_ins += sprintf(stmt_ins, "NULL,");
  			}
-			sprintf(stmt_ins, "',");
  			break;
  		case ULOGD_RET_RAWSTR:
  			sprintf(stmt_ins, "%s,", (char *) res->u.value.ptr);



--
Here is a patch of ulogd.c that fixes the ULOGD_RET_RAWSTR issues by 
adding it on ulogd_key_size() (using the first "solution") and to 
type_to_string() as a "raw string" :

--- src/ulogd.c	2016-12-17 16:25:45.000000000 +0100
+++ src/ulogd.c	2017-10-02 18:01:26.413740164 +0200
@@ -188,6 +188,7 @@
  		ret = 8;
  		break;
  	case ULOGD_RET_IP6ADDR:
+	case ULOGD_RET_RAWSTR:
  		ret = 16;
  		break;
  	case ULOGD_RET_STRING:
@@ -306,6 +307,9 @@
  		case ULOGD_RET_RAW:
  			return strdup("raw data");
  			break;
+		case ULOGD_RET_RAWSTR:
+			return strdup("raw string");
+			break;
  		default:
  			return strdup("Unknown type");
  	}

