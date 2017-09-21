From: Jean Weisbuch <jean@phpnet.org>
Subject: [ulog2 PATCH] Non-arbitrary malloc for SQL queries + string length
 limit
Date: Thu, 21 Sep 2017 19:00:47 +0200
Message-ID: <bcadb7a2-d429-af84-e871-167da12e0819@phpnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from chartreuse.phpnet.org ([46.255.160.25]:52870 "EHLO
        chartreuse.phpnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751709AbdIURLs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2017 13:11:48 -0400
Received: from taillefer.phpnet.org (taillefer.phpnet.org [194.110.192.54])
        by chartreuse.phpnet.org (Postfix) with ESMTPS id E44C8630D8
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Sep 2017 19:00:53 +0200 (CEST)
Received: from mailfilter2.phpnet.org (mailfilter2.phpnet.org [195.144.11.141])
        by taillefer.phpnet.org (Postfix) with SMTP id 68F18710075F
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Sep 2017 19:00:51 +0200 (CEST)
Received: from rt-bur1.phpnet.org ([195.144.11.241] helo=[192.168.1.145])
        by smtpbisbis.phpnet.org with esmtpa (Exim 4.80)
        (envelope-from <jean@phpnet.org>)
        id 1dv4qJ-0002yI-AX
        for netfilter-devel@vger.kernel.org; Thu, 21 Sep 2017 19:00:51 +0200
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I developed a filter module for ulogd2 similar to the PWSNIFF module 
that is getting the hostname and URI of HTTP GET/POST requests from raw 
packets and i was experiencing segfaults when long values were passed to 
escape_string().

Its due to the fact that sql_createstmt() allocates 100 bytes per key, 
no mater what their type and content is and there is no check on the 
length of strings.

In my usecase case, strings can be quite long, especially when there are 
chars that needs to be escaped, making the statement even longer.


This patch makes the allocation more "dynamic" for integers and safer 
for strings :

   - Integers are now reserving only the maximum possible number of 
bytes they could use (eg. ULOGD_RET_INT32 lowest value is -2147483648 
which is 11 characters long : it will now only allocates 11 bytes for 
those keys instead of 100)

   - For strings, SQL_STRINGSIZE now defines the max length of values 
(before being escaped), longer values will be truncated and the double 
of SQL_STRINGSIZE is allocated in case all characters would have to be 
escaped


I am not sure that truncating values is the best course of action, maybe 
replacing the string with NULL or an empty string would be better?


Patch on the 2.0.5 codebase :

--- db.c	2014-03-23 16:30:50.000000000 +0100
+++ db.c	2017-09-21 18:38:47.810209209 +0200
@@ -57,7 +57,8 @@
  }
  
  #define SQL_INSERTTEMPL   "SELECT P(Y)"
-#define SQL_VALSIZE	100
+/* Maximum string length (non-escaped), will be truncated to this length if longer */
+#define SQL_STRINGSIZE	255
  
  /* create the static part of our insert statement */
  static int sql_createstmt(struct ulogd_pluginstance *upi)
@@ -78,13 +79,28 @@
  	for (i = 0; i < upi->input.num_keys; i++) {
  		if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
  			continue;
+
+		struct ulogd_key *key = upi->input.keys[i].u.source;
+		unsigned int key_length = 4;
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
@@ -373,14 +389,23 @@
  			sprintf(stmt_ins, "'%d',", res->u.value.b);
  			break;
  		case ULOGD_RET_STRING:
-			*(stmt_ins++) = '\'';
  			if (res->u.value.ptr) {
-				stmt_ins +=
-				di->driver->escape_string(upi, stmt_ins,
-							  res->u.value.ptr,
-							strlen(res->u.value.ptr));
+				/* stmt_len is the length of the non-escaped string, it cannot be longer than SQL_STRINGSIZE */
+				size_t stmt_len;
+				if(strlen(res->u.value.ptr) > SQL_STRINGSIZE) {
+					ulogd_log(ULOGD_ERROR, "%s string is >%d chars long, truncating it", upi->input.keys[i].name, SQL_STRINGSIZE);
+					stmt_len = SQL_STRINGSIZE;
+				} else {
+					stmt_len = strlen(res->u.value.ptr);
+				}
+
+				*(stmt_ins++) = '\'';
+				stmt_ins += di->driver->escape_string(upi, stmt_ins, res->u.value.ptr, stmt_len);
+				stmt_ins += sprintf(stmt_ins, "\',");
+			} else {
+				ulogd_log(ULOGD_NOTICE, "No string passed for the key %s, setting the value to NULL", upi->input.keys[i].name);
+				stmt_ins += sprintf(stmt_ins, "NULL,");
  			}
-			sprintf(stmt_ins, "',");
  			break;
  		case ULOGD_RET_RAWSTR:
  			sprintf(stmt_ins, "%s,", (char *) res->u.value.ptr);

