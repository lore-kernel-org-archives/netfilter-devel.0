Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710DD1422DD
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 14:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741791155; cv=none; b=YTtV4nIri/5H8DhiL5DZrtIW3izFLXq/aqJ1VACy3n3eJ2U1QeYLk4VscXZdG8XNn6p9z5v01FrYg2Bv72zby5mItwM+XN77+/795PhJDI6cX7RzfuW2fC3XHlqbxI2ilOYaLK9EIsELRJOYsBlviuPvBYnMCog6oSOmlcNi07o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741791155; c=relaxed/simple;
	bh=srfOy4FIyYzrYjeClTGzvaG7hh4g8AQkbukRY4gApS4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=F8r7Sn8CnFqtj2ieNr7jP6h9N8CBWcIkJ3IlIS1ZaqgQqjlcB2Gy6rV/1LD02vmbg7SM8m4Pwk06XUd0RAtwOQaHdl4rVtnpX/e3yE23RdHSIE4pmOj0fjI93zDXvI0stUgcGmP4A2XoOIkGGbdNew/B6vxbLBFc+BwOF8hP9rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=UB68aVaE; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="UB68aVaE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741791149; x=1742395949; i=corubba@gmx.de;
	bh=K+P3EOK4UFcz2iAGdoAwhPR6MsXKnbwQecuksnMiJbY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=UB68aVaEW2uCmR9pK3tPr75jRI83/OMDKE+O8AFWdGPseh9RdyK9TR0qe+VQsfJo
	 zxWw+lx1Z3Ia9eIGLlRi7F3xuFW6tPHICtykynGHjkLLyseoiUN6iJ6de9GYVn2ME
	 aTEDy82DBKZP6/PDQAvK63EKISxtOq2zYR63DRsYB++JGmzsGXFT0WJtwEI/pYcMn
	 ygsb/RHceUifay30QVS2g6upZdTF6ygb5trANdVR5+APQWIUq0K6GcgHa1O8oeibS
	 Qz0arBqvCtUVcCGtw9lJEiic2ChQdcf/1gUi/i3XlVHBiYw3kKOAA3fuC84hUZbGg
	 l6ZXb0B9u2bifILsBQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.254]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N33Ib-1tDM8G1pfx-00r1OV for
 <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 15:52:29 +0100
Message-ID: <1a5fff4d-4cef-48e3-a77c-bb4f7098f35b@gmx.de>
Date: Wed, 12 Mar 2025 15:52:29 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
To: netfilter-devel@vger.kernel.org
From: Corubba Smith <corubba@gmx.de>
Subject: [PATCH ulogd2,v2 1/6] ulogd: add ulogd_parse_configfile public
 function
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:663KPotR7X1S+Hrv54MUhl9m/6tvz8kkFZbMQyjeqEwaxAJdRlo
 2uWw2xLcJGbQIchguy9zvGIykun7NfXL18M2rxgYSS87f3Sr4g8Gw1bz7c1Lmky5wWSIIc2
 F+Q9zBX7s/FLo7aWU9el8fxqJg65LL5txrjLgQwfDueKTFRplo4gG+JAqcpwH/eWQ+AqAaE
 PzMFxHyq3L28GAHIhJY/Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bUKWWJFcw6w=;HrdsNT6Kl5KmvbiN9AcuxNfifkT
 Na05oc1v4TkYvyfD85LtRJV06/SWYb54bQAGP/5sPYCLLBRS2kj14SrHT55SyaLvWLaPcU8Z4
 jvkJ4tXhvdJo/1D/MVnHG8bkKs7zm8V/vX7Wp6qfqmX4ZMY6oxQRPEiar32ntmL0TiZux0eqf
 DLciR/MVUpI7fgmQxLgsR+OdMptjZDpppI9zce0EKjT95yzWmD29x0k5OtxgYsjlzBPrhgDcc
 /lhuDhanMEPpOqd8U1XSTYIc90ewXOTt99kfI3+KZn6e2NBdqXFQYCQ1xARZ/lAKY6lo7+wzY
 ZEEk6nY+dl0y8WmZOlzggMODfJoWgBDA5lKGVpezwTvalTSg4eq19CPzx5p12HWsDvkB0Kztg
 yyTqlLyuoPPGkCNpi71OR6eA+hC1WlHC0Cwj90AVZTSfL8ipZt61BNFffec+YAM6w+7lhWYum
 tUjKhea4VxssRcRmLiQTcgJ05xYwE72mQnXGKuaZN3UiFnpn2EGf4qZpjglZO4+JRHdyiHeWH
 xy607ojXpICTz4WgYJizy65DbXqmJlsd8nWxIV8EAqQwmzBpbuyaykPud4Sj35JRyRn58HlJI
 cTAix0QWPKtGoMgZlbJOJ3cf1EG4Nip1SZrdENYfo5HcqVHDd/7B1ZP3QRlWMR/8YDzqdY0AJ
 VbWCRtkjABOQRnod7S9pzTxcD1TL28Wijy1xMDV2AVBhD91M+G0oQ9u7tTLF6mhGYVcyHtEC5
 /iQ1hkzMfIr94TRTJKq6Cf1bmox1RMP5H8I7RxkmrJlHsyoB1Pk5POD5t26mDi2L4Cbj2d2eQ
 GIxGpZ0tdlofyOviQRDem83+sF978TU+ksnzmpqTRR8uNHirsYz8GJldlz/AmlJJjXpWT9Lns
 kuXEVZ9v+nGYDgvt502SUTGpMxpS9zXgaxerezQky8JgtfUn7/9nBIac3G+O+25SfzF6Vdmat
 e1xjRHgxmqcOImTLEcZ2Cpk3RETG2geeKyIh5ohaPwH7xTzUze9pcCfl0w0KXJKEXiK0G9ZCb
 8of5isIq+RRmU29RQSTSGgvJx2MhmpiAlxhrYkkQs4+Oy/EBAxHaEMMH0QOgFbTw/N+2H8VIG
 dvRdbDoO4Xcwetb26HXbUQfsui0x6ZMdiILEuNNtV8Yk8OTeOMmcyTg0JXOa53EHw5LP7oiz3
 HUwK0ZWkAcgljij4DYe4BUZYRab/oPRjvd1EMYyMeuv3HvENVJqPaq48IoRSFd+olFUwFy1ef
 ZAb6hW3LgZFSngdzbbr3a5I1gD23JGkhvXAVbPV58vvrK3fzMoyXngbxWIPBjI9iTbD6BvOC9
 KsnLCDsbsO2IFsvK5OUBjSV8XfwUiQ0COBd6EKUvU/C5xCU/e5+V+dTHZB8fXyP5K8wVp4ZfC
 Mi+kqeiFCyZgIs1zoS8Ggn5TrlJu3m/1CUwuaYDiZ3YbalmDIsMtvhZraj9AaqCBCDSsydbzg
 XcRHsTOhTR3gCBhQZW7Fz/rJvvzZfeLh2U8Ey0J3ZCV4npFJG

Provide a new function `ulogd_parse_configfile()` in the public
interface, which wraps `parse_config_file()` to parse a section of the
config file and communicates found errors to the user. It can be used
as a drop-in replacement because arguments and return value are
compatible.

This relieves plugins of the need to translate the individual error
codes to human readable messages, and plugins are mostly interested if
there is any error, not what specific error.

This reuses the existing `parse_conffile()` function with slight
adjustments.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
Changes in v2:
  - Rebase onto master branch (b9f931e2f30e ("nfct: add icmpv6"))
  - Renumber the patchset since v1 patch #1 and #5 are already applied
  - Reduce indentation of case statements (Florian Westphal)
  - Link to v1: https://lore.kernel.org/netfilter-devel/ca5581f5-5e54-47f5=
-97c8-bcc788c77781@gmx.de/

 include/ulogd/ulogd.h |   1 +
 src/ulogd.c           | 104 ++++++++++++++++++++++--------------------
 2 files changed, 56 insertions(+), 49 deletions(-)

diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index c7cf402..088d85d 100644
=2D-- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -362,6 +362,7 @@ void __ulogd_log(int level, char *file, int line, cons=
t char *message, ...)

 int ulogd_key_size(struct ulogd_key *key);
 int ulogd_wildcard_inputkeys(struct ulogd_pluginstance *upi);
+int ulogd_parse_configfile(const char *section, struct config_keyset *ce)=
;

 /***********************************************************************
  * file descriptor handling
diff --git a/src/ulogd.c b/src/ulogd.c
index 9a0060d..51aa2b9 100644
=2D-- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -251,6 +251,60 @@ int ulogd_wildcard_inputkeys(struct ulogd_pluginstanc=
e *upi)
 	return 0;
 }

+/**
+ * Parse the given section in the config file into the given keyset.
+ * Returns ULOGD_IRET_OK on success, ULOGD_IRET_ERR on error.
+ * If an error occurs, writes a descriptive message to the log.
+ */
+int ulogd_parse_configfile(const char *section, struct config_keyset *ce)
+{
+	int err;
+
+	err =3D config_parse_file(section, ce);
+
+	switch(err) {
+	case 0:
+		return ULOGD_IRET_OK;
+		break;
+	case -ERROPEN:
+		ulogd_log(ULOGD_ERROR,
+		          "unable to open configfile: %s\n",
+		          ulogd_configfile);
+		break;
+	case -ERRMAND:
+		ulogd_log(ULOGD_ERROR,
+		          "mandatory option \"%s\" not found\n",
+		          config_errce->key);
+		break;
+	case -ERRMULT:
+		ulogd_log(ULOGD_ERROR,
+		          "option \"%s\" occurred more than once\n",
+		          config_errce->key);
+		break;
+	case -ERRUNKN:
+		ulogd_log(ULOGD_ERROR,
+		          "unknown config key \"%s\"\n",
+		          config_errce->key);
+		break;
+	case -ERRSECTION:
+		ulogd_log(ULOGD_ERROR,
+		          "section \"%s\" not found\n",
+		          section);
+		break;
+	case -ERRTOOLONG:
+		if (config_errce !=3D NULL)
+			ulogd_log(ULOGD_ERROR,
+			          "string value too long for key \"%s\"\n",
+			          config_errce->key);
+		else
+			ulogd_log(ULOGD_ERROR,
+			          "string value is too long\n");
+		break;
+	}
+
+	return ULOGD_IRET_ERR;
+}
+

 /***********************************************************************
  * PLUGIN MANAGEMENT
@@ -1098,54 +1152,6 @@ static int logfile_open(const char *name)
 	return 0;
 }

-/* wrapper to handle conffile error codes */
-static int parse_conffile(const char *section, struct config_keyset *ce)
-{
-	int err;
-
-	err =3D config_parse_file(section, ce);
-
-	switch(err) {
-		case 0:
-			return 0;
-			break;
-		case -ERROPEN:
-			ulogd_log(ULOGD_ERROR,
-				"unable to open configfile: %s\n",
-				ulogd_configfile);
-			break;
-		case -ERRMAND:
-			ulogd_log(ULOGD_ERROR,
-				"mandatory option \"%s\" not found\n",
-				config_errce->key);
-			break;
-		case -ERRMULT:
-			ulogd_log(ULOGD_ERROR,
-				"option \"%s\" occurred more than once\n",
-				config_errce->key);
-			break;
-		case -ERRUNKN:
-			ulogd_log(ULOGD_ERROR,
-				"unknown config key \"%s\"\n",
-				config_errce->key);
-			break;
-		case -ERRSECTION:
-			ulogd_log(ULOGD_ERROR,
-				"section \"%s\" not found\n", section);
-			break;
-		case -ERRTOOLONG:
-			if (config_errce)
-				ulogd_log(ULOGD_ERROR,
-					  "string value too long for key \"%s\"\n",
-					  config_errce->key);
-			else
-				ulogd_log(ULOGD_ERROR,
-					  "string value is too long\n");
-			break;
-	}
-	return 1;
-}
-
 /*
  * Apply F_WRLCK to fd using fcntl().
  *
@@ -1592,7 +1598,7 @@ int main(int argc, char* argv[])
 	}

 	/* parse config file */
-	if (parse_conffile("global", &ulogd_kset)) {
+	if (ulogd_parse_configfile("global", &ulogd_kset)) {
 		ulogd_log(ULOGD_FATAL, "unable to parse config file\n");
 		warn_and_exit(daemonize);
 	}
=2D-
2.48.1
