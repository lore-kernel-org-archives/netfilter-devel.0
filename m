Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966BE19EEBD
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 22:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741473234; cv=none; b=Tg+Ig3veVjxaAUa3lfnjeLmOZkNbvvP7kjsl7/fQ44G0TGgcy8Ggqi/GmBsMtrUM5cS3sMH1lkjQWZHR/c2B/+jR3N52JkO6//MGp9rV7I+Cc9XNG+WFHIazf2Nhc984oXef41wLxJgXvFKi/QoYAq13JbmEf1CQZeSn+UNGyHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741473234; c=relaxed/simple;
	bh=7bwtM2jLJpk9CjFET0AHY2MmbwNjt12JTmsZrFlW8UE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=icDpARVpNjhEhg9ROQZp/YV3q8+KKUvjJVsg6nOw8pXOugZ0/U/dxpeuEinB7EpIw+Tm8rsd4tketTkeALpzni9bUj7e8KP+gWUyRraDSqE9hH31u5Uh+GgEN8sGOANDVJzCFVR1B8Hie5OrP8Yiv9prw85mrHg4ksOmOmiN6a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=iMvHNNMK; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="iMvHNNMK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741473229; x=1742078029; i=corubba@gmx.de;
	bh=6BDTTxnt4ksFC8/JSayVR+0ZoYUJeQgPxnH0tpkvcp4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=iMvHNNMKpX/uDtMQolrL1OVbbOnL+3xT/R2Tchcbd1GN6QLdUUGGNaiAgA+5brxH
	 MZvwaMhaNOGL5a2WSbqlD/msjBQRiEriDgZfjOIgO3UWOr9/CMO6ZtGchV1YfFOdp
	 Ug5pVZacPjvKrmK3rCPTHMTA0sOfr19jcxyAYuuQ0FlSukpwMU8r2k5AdNlWFnYIX
	 dWOWqilHIDO1eiJNH6UfJHD6QlI0P6SP7zdD9NhjNYlVhWcm4I7TREbZ4ORvPP3kt
	 a8ArSifLWWjdufMRQn81RsMRsH1SY+Nmxpd+76HQltr20gorPoV9OBBCLD/SZGBAO
	 Ls5PJxiB4hVh/THhfw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.164]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MS3mt-1tgqO62Ibz-00Qne2 for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2025 23:33:49 +0100
Message-ID: <4d7fe1dc-73ee-4e9e-b418-8f5fb87c1e4c@gmx.de>
Date: Sat, 8 Mar 2025 23:33:49 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 2/8] ulogd: add ulogd_parse_configfile public function
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Language: de-CH
In-Reply-To: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Y4Hce4OH7nVGA20BSagYggsDtuU2SnsmESaHiLNusuhH6zx9brK
 c+7YCj5H1C0gf/QslEd22u/2WDlgoAE4emXQ+7TEsMt+8/KHZML9gDMMVq/zV7zMfMyVu6L
 wYRjR0Yda4DQF1kTz3kLmLdLV95kDZirYT6HO+PeNpGi0484DkUVQHlefAjaOkyryjlaohX
 EfiaiGU/0jw88JkH4DiYg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:fJ/a4/ctse8=;nnXpsPcMpusqpGEJb45EBMxvWgt
 dfmmM3IP2ZRwMKp5h7gvJqXOEkoaQ9R6h9X8o1+7kri9aXPPmoxplljE65T52gUFe3G2S+aXJ
 vo8c1TQKo+Gt3jfWbSYxkAHz4ZEyuRh1lWZJ/VFEXvDJPxTR+nUedJWD37BfIiIVxiaB4wrxh
 JOa8CBywDvcyU/My4e2o1XupU8utN9k4wv0MQJgUBjW0SV0ltvmygo4DQValfaHOcEM9L6GGr
 1tQt3wcObnevdv3l9ZciiyMeATXsyjHV6bOkICenYV5GZPCekXO7jq83Wr9SZNI957ClEMl9L
 YJafqqFCJUjYUCJYqmEM3l5NPggzEWHURMdTS4QOZyjeptkpCEdOSxbiDszRtTKKa7vpzXjjP
 ATiFHLaO0D1BF+m6bShHKJXolDKnqAroSR0IMJay+KI+HH/Pp6vJ6K5yY2wfWTeIDvnyw8iWe
 buUKcHlZNo4eB40PhrY0P6jsy3u5+2tOzCBCFn6xaQkbPdu4wIHRYI3oCzzMNBOrvRX4+a9Kz
 JPCl7MSNqJwjNxU5hjknQalLCb50af73Csakv9Z3v9n0O+73ZFzgAZY4lrhOxnuFUAABO0969
 wkjrJ4PspRAagHIXzlb/j6TwwdcmZAo4IxTGOq2sN1ZMqOjHX9Z2HXAai/N87n3lNKB1B0Dk3
 xYrEMqyqCVZhYttbJE7Rnkq+Y9sw7TaZCBMQATjTQVGHtrGnnPpcZseiFchmN6YbuookVlohB
 RyBYiogFyrfx5tAHUEFmyCGeqP8r20HAmfzac15RTNJm8ea+17AMTRJTzgm8gH5osHl9DdrZS
 Q6b2ZTidga414iFEddgubW5ZTUE9FWIKfLP4LmJZAOt74GV1Ggg2p94aLECYlL0xClgL7wDTv
 ce+9sofRGXY8EO1IMehqCzZlfhUCDFr9osYvpv83uZPCBLsuAptkQ3hRWKW9nf4ST2QWMcULS
 OgwPXme741fUOwTqs9hnUvUQBkNKeI1viTYjFZeqLmokt7Tg8PBza6huf1dmgBStJJNT/LusX
 CxyAYzFN+DuBMFl7yneEaF+x7D98miAK29L1WMCfN9zh57BWigF8h5hlyqHm+9zB78upRZdF/
 ryccBa1N7b22JkEkTPm4EAe8MT6h161ZkCP03JNvYpVMKSAzKPJOIqdM2ymX+eR4zoi0U13QM
 2YXRkAni6gSkDrJKs7qeDlxOVy2io4k3CHKYxCGnCpil0gAJHxFjMh/dv/Hh3RsBYHHqTY+Of
 /J7Auh6Op/P7D+zbzOVjAKmpeh4RFqAdV1cC236D21jyF3vQotukVQ/LIg37t+NUsWyxl9vEB
 ymnr0BeaeUnhkOUgBoRSffeJIQ0zZoz5G3DHaqH+VruPceWFh8Rtjgo16sVmWaw2lhwtyJSCk
 lbdygjlOaQG/fVP0atEDmRIa5XnOKZEfs1mlYFsJ1UZ3Noa7Cz6D8HOMkT

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
index 6c5ff9a..80e1ac0 100644
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
+		case 0:
+			return ULOGD_IRET_OK;
+			break;
+		case -ERROPEN:
+			ulogd_log(ULOGD_ERROR,
+			          "unable to open configfile: %s\n",
+			          ulogd_configfile);
+			break;
+		case -ERRMAND:
+			ulogd_log(ULOGD_ERROR,
+			          "mandatory option \"%s\" not found\n",
+			          config_errce->key);
+			break;
+		case -ERRMULT:
+			ulogd_log(ULOGD_ERROR,
+			          "option \"%s\" occurred more than once\n",
+			          config_errce->key);
+			break;
+		case -ERRUNKN:
+			ulogd_log(ULOGD_ERROR,
+			          "unknown config key \"%s\"\n",
+			          config_errce->key);
+			break;
+		case -ERRSECTION:
+			ulogd_log(ULOGD_ERROR,
+			          "section \"%s\" not found\n",
+			          section);
+			break;
+		case -ERRTOOLONG:
+			if (config_errce !=3D NULL)
+				ulogd_log(ULOGD_ERROR,
+				          "string value too long for key \"%s\"\n",
+				          config_errce->key);
+			else
+				ulogd_log(ULOGD_ERROR,
+				          "string value is too long\n");
+			break;
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
@@ -1594,7 +1600,7 @@ int main(int argc, char* argv[])
 	}

 	/* parse config file */
-	if (parse_conffile("global", &ulogd_kset)) {
+	if (ulogd_parse_configfile("global", &ulogd_kset)) {
 		ulogd_log(ULOGD_FATAL, "unable to parse config file\n");
 		warn_and_exit(daemonize);
 	}
=2D-
2.48.1

