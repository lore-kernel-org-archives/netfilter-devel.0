Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E42518DB2A
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Feb 2025 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739714569; cv=none; b=U6+6CopTZlOh1ekZpggt//rySyvt29lN+aPDuab5Mn04Yd1WyjHtfzSgbYiqUtDt/dLgVidPeO4AUwqacwle89IukF2bppQi5IULnLfbOJrg7m3QrYzklg8IU6Gjou31xOpNZdiZrb2CqI6KlOoewy/DEUkW30Nne17QQTHeBi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739714569; c=relaxed/simple;
	bh=eD1WAXLKZKHqIUPLZXk9JqGwhPKD2BkQZDVOctddpI0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=mSQuf95IE3Ac8RN29/FKkSVEjhCkvwmZu3SxjhMCLMDxCVEwQpBTTmqFFTQ8G+5KSuM4tPCqa46lGDEa6YtmMIxx2C0N1i68PW4JhF3uRPvb2ACYEECpD5g7iCMXyfiMPaBNGU6Ah+hoc5NcKBGEr/vSs09Q36ze77ZLW5/raMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=orJjRbbY; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="orJjRbbY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1739714565; x=1740319365; i=corubba@gmx.de;
	bh=qbRNQcG5SgoGMB2e7zT62jfmBMVLDKFsV6NWOVxS1G4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=orJjRbbY0ZLvOGFCY2qj/W/86sIyY8mtHocdD1/ZNYC34KkT0025esqqP90aTulU
	 HEKCdw+SRj4NC78Yd7OGkunWBnAcYfMhMekzvoLniqbe+1KYmis8CCcfQjHQu66/n
	 8q1DfWbDpuXeJX/I1YHIDjOapmZ2GYA48xK1V9LggOpb+lGDSGMZcUC5jcFTqyvym
	 kqQq/DcS3NlccK5MTnsm8NyQNS//stBOLwvDC7Z6oto+o6y6S3/TrN5jAGQ+yu5JN
	 yhHZL+S83m524AMfcAUExhJ9aw9tvUbWRnKn3PhPizEwnVtsECTNs/H7vJRzTFIvp
	 8kWrouRfawynotDR6w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.182]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N4hvb-1tKPNy1b9j-00xDbA for
 <netfilter-devel@vger.kernel.org>; Sun, 16 Feb 2025 15:02:45 +0100
Message-ID: <54d0f56f-9f50-4215-9dc2-882d0e194ae0@gmx.de>
Date: Sun, 16 Feb 2025 15:02:45 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 v2 1/3] nfct: add newline to reliable log message
Content-Language: de-CH
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <6b8f641d-7ed2-4e1a-8ecc-c77488f71f00@gmx.de>
In-Reply-To: <6b8f641d-7ed2-4e1a-8ecc-c77488f71f00@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:bYQxPc1NuZULK/gLykfRFm2y7ekcXXU6jc29AAh9zBsQ4uGsE+k
 MvowrHVbV2utcKxuHzkEWQLHqmjO77QaZG3UXfLjwaPoznHr17TQRVAEgu7FEMJe+yqDdtB
 BdJgvQOu4xJVBVFsSh8BU0FDom/yY1+c8TqGqPI90tAxTiB1QVL3VzQZ30gb3/PomeYeVhP
 SlnXq56EwrsDdJc+L1Qzw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kFJAKmANvKs=;Yu0j9wz214KR5Xhw7sbKYWS2mZM
 WwpPtNpPXDfzVBdiZ0z0xptdAMwhDXR0lXjyi1FL1EcyT1VFaLZIOTpdNY1BscAPVvenoPyvn
 OKrUjNfBNHSicAEsQmr0MvJ27b7Q/RdZ/gjLYIobq2j0zKg46AOM1YtURpIOZyqjMl10k0g1O
 3TcdOuxKhtoopeyDMPyKQy5N0OPRobtnqQF70QKEUsikTehSQGTAkqRVkJ+g2g+z1Nk8qaSUv
 kbovvfPZC/BA431fvAC9DB2HISdvCjKiVCt9xt573BGtk1FiqNPdpzM7+ZI+r2AlWPHM133QW
 wk1liEMr0AXnMPBu24bfxOdboC2CShYEUAfKnoa291aZ1H6v46izC/BHQd97GbDtJ247P7fZ4
 f+tbopuExtwnS+YiQmyPp3jlrwAggjk+QlLmorWSfGdIYihyTpIvhy4X7qR1GXxVKlnVUhdIb
 KPxK+28aRYJfcSUwOWiOCEDRUg7pswpSoZ3n0nfvIxNBKX89FDMNbGEAgnPpn9B0gi1rXm/sB
 oK6radTbz8lvOQTC9LsSZfyKhy3txyma9Fp3D+KJ+3BW2BqEZi3CoOmVlLO3xLeh56+O/pon0
 +UNd+px23/afHKwZSTCrt7d6LFssMRl0kU46bOjFP3neIQUR5qyPfeDWmEMhc8kg/HFD/VOv5
 oQOZ9gS4OpjrFeQaaT+rqSxEcxP+q6J3q7rkNsVkfjRDseKtgJQvUyN09mCuQKSY589ZXn1af
 SOp5xd17sVysrR9FrJ2GFa7Xau0OmVu8s/duyRRmEMeaMclmfcORBI8M3MDkTBbaktMbGuOPz
 H5Hh2niydroRcmNeRIjIP4/YBvAQ/BQa69USVLnc+BcvchYo/Cli7+L9nf0Se36E0KBf3Fq9l
 E/zf/4JIstJ4G2AR0ADfXtpBM2lXVUuSFslQsJYwK4hZ8WusDpvkW9aZ15LM7MeNq1TSf91tH
 vQ2iYyQimr1f140SXxpCI9mMp5zxqq6hhS/wKCXlizezHBQ2s4Izn8MfuUxLD8I9tR3lLPjjv
 kMElrfoEY/MKEXlEd2jbSYel7g9dsiF8oQ0DJlk/vCXkdM0oHqvyfGI87Z8EOyrdoWLUEw6Ff
 7BNdHpnPH0u3fSw1cqc2i2a7LGHAjj85q8CxoOy8yLXw8sfNXmLkG6Qe8v5UhRzr+Sj9VQvQ6
 P0CWBLzzXqSzSVkCwTL5TBqNG/lpLy0GvUdpMPjDBwZWG3pLfqHuMfZW58Mr0keZSMMK9PI68
 PtSASQOSONNcTlLAwfgjd7I13dlnr2AJ+RICACOm5nK3TO1jKxJeDPTMZhEDRGCiglgA8Bfvp
 gJfqttUtwswNZuj/Bb82HN6vtoMcoB+y74Ky+y0/MdntZlB/SjGuwaZF79Uu3Vm9g2fGwB7/l
 wUseCmoJP7j6smr9/1ytRVS4Gh3Uvi1T5KpdYSyrLF7exWqOV6Wk6s31nl


Fixes: 4bc3b22e426d ("NFCT: add `reliable' config option to enable reliabl=
e flow-based logging")
Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 input/flow/ulogd_inpflow_NFCT.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NF=
CT.c
index 899b7e3..983c8d6 100644
=2D-- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -1327,7 +1327,7 @@ static int constructor_nfct_events(struct ulogd_plug=
instance *upi)
 		setsockopt(nfct_fd(cpi->cth), SOL_NETLINK,
 				NETLINK_NO_ENOBUFS, &on, sizeof(int));
 		ulogd_log(ULOGD_NOTICE, "NFCT reliable logging "
-					"has been enabled.");
+					"has been enabled.\n");
 	}
 	cpi->nfct_fd.fd =3D nfct_fd(cpi->cth);
 	cpi->nfct_fd.cb =3D &read_cb_nfct;
=2D-
2.48.1

