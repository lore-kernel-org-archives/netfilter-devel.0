From: Jean Weisbuch <jean@phpnet.org>
Subject: Re: [ulog2 PATCH] Non-arbitrary malloc for SQL queries + string
 length limit
Date: Mon, 2 Oct 2017 14:54:33 +0200
Message-ID: <025be696-ba9b-ad63-96cb-0db137acd3c9@phpnet.org>
References: <bcadb7a2-d429-af84-e871-167da12e0819@phpnet.org>
 <nycvar.YFH.7.76.1709220841540.12548@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from chartreuse.phpnet.org ([46.255.160.25]:54660 "EHLO
        chartreuse.phpnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbdJBM6M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2017 08:58:12 -0400
Received: from taillefer.phpnet.org (taillefer.phpnet.org [194.110.192.54])
        by chartreuse.phpnet.org (Postfix) with ESMTPS id 45E2569CC9
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2017 14:54:35 +0200 (CEST)
Received: from mailfilter2.phpnet.org (mailfilter2.phpnet.org [195.144.11.141])
        by taillefer.phpnet.org (Postfix) with SMTP id 694A77100ACD
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2017 14:54:33 +0200 (CEST)
Received: from rt-bur1.phpnet.org ([195.144.11.241] helo=[192.168.1.145])
        by smtpbisbis.phpnet.org with esmtpa (Exim 4.80)
        (envelope-from <jean@phpnet.org>)
        id 1dz0Ez-00021F-9J
        for netfilter-devel@vger.kernel.org; Mon, 02 Oct 2017 14:54:33 +0200
In-Reply-To: <nycvar.YFH.7.76.1709220841540.12548@n3.vanv.qr>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 22/09/2017 à 08:44, Jan Engelhardt a écrit :

> On Thursday 2017-09-21 19:00, Jean Weisbuch wrote:
>>    - For strings, SQL_STRINGSIZE now defines the max length of values (before
>> being escaped), longer values will be truncated and the double of
>> SQL_STRINGSIZE is allocated in case all characters would have to be escaped
>>
>> I am not sure that truncating values is the best course of action, maybe
>> replacing the string with NULL or an empty string would be better?
> Silent truncation is really bad. If the currenty query length can be externally
> influenced (and I have no doubt that it can), you may end up executing a
> different statement than what was intended.
>
> Return an error code from the function, abort() the entire program, or
> something. But don't silently truncate.

Here is a revised patch that does set the value to NULL instead of 
truncating it.

I dont know how to cleanly abort the query generation if its what would 
be prefered.

--- db.c	2017-10-02 14:44:05.000000000 +0200
+++ db.c	2017-10-02 14:52:05.883528350 +0200
@@ -57,7 +57,8 @@
  }
  
  #define SQL_INSERTTEMPL   "SELECT P(Y)"
-#define SQL_VALSIZE	100
+/* Maximum string length (non-escaped), will be replaced with NULL if longer */
+#define SQL_STRINGSIZE	255
  
  /* create the static part of our insert statement */
  static int sql_createstmt(struct ulogd_pluginstance *upi)
@@ -78,13 +79,28 @@
  	for (i = 0; i < upi->input.num_keys; i++) {
  		if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
  			continue;
+
+		struct ulogd_key *key = upi->input.keys[i].u.source;
+		unsigned short key_length = 4;
+
  		/* we need space for the key and a comma, as well as
-		 * enough space for the values */
-		size += strlen(upi->input.keys[i].name) + 1 + SQL_VALSIZE;
+		 * enough space for the values (and quotes around strings) */
+		if(key->type == ULOGD_RET_STRING) {
+			/* SQL_STRINGSIZE is the max (VAR)CHAR length, *2 in case every of its characters would be escaped and +3 for the quotes around the string and the comma at the end */
+			ulogd_log(ULOGD_DEBUG, "allocating %u bytes for string %s of type %s", (SQL_STRINGSIZE * 2) + 3, key->name, type_to_string(key->type));
+			size += (SQL_STRINGSIZE * 2) + 3;
+		} else {
+			/* key_length is the maximum strlen for the specified integer type (ex: ULOGD_RET_INT32 lowest value is -2147483648 which is 11 characters long) */
+			key_length = 10*ulogd_key_size(key)*8/33+2;
+			ulogd_log(ULOGD_DEBUG, "allocating %u bytes for int %s of type %s", key_length, upi->input.keys[i].name, type_to_string(key->type));
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
@@ -373,14 +389,20 @@
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

