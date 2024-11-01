Received: from sonic309-22.consmr.mail.bf2.yahoo.com (sonic309-22.consmr.mail.bf2.yahoo.com [74.6.129.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A081C830D
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Nov 2024 16:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.129.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730477695; cv=none; b=d8fZZ9XJS+0M0KNJlezSZwOiegmC/cS6wKER1NwVwjJ5DKareFP+g2vgtf2DY/7NcLI5gs/QQ9db+IpLfrAbgEF97DT9Qgl9SRJJqblT/iZlXonqD8SDctwdM87Yz7499QhYLm20vEnjorefvPs6vN9ayUkmXYoHDlXiFJlKSOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730477695; c=relaxed/simple;
	bh=3yJQ4JN71QuLtjWEXWObJKKEc3cN49wU3UwTo+2VJh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WEBT1w0ZqOE4pIJy9oSiqLd5sv/W7g88Oi91hufaAKK5pt0Ob7IPAq9wXDePVK5zcSAEMK6EOoR9hacGMUWLA5njgPAV8wqBHwbeYKE2KeTT8HRNhXUnrqJzBUYaqrHd5kfjk2r/tvF2IfBrkWeelsxhadSZ+mdrMQGeBXJtxhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=M28WUSQ/; arc=none smtp.client-ip=74.6.129.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="M28WUSQ/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1730477692; bh=3yJQ4JN71QuLtjWEXWObJKKEc3cN49wU3UwTo+2VJh4=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=M28WUSQ/t7gps2rB7Xl7p35+fUa4xzqUBgmJ3a0dSaD2PIEVrdhk1p/tnZMDKPNF31nhOCsxp09IDcm/KVivd7ru5Wn8FTq+vzG1yZl6ENFsSBrL91B6o1oz2Q44ePcE0wV0a/KjnJmLmPnyZ/a617wideROzHXu5s7b0AlBl+UofOkII1IsN06xXj8C7PB/h+RM7CgHWNm93F+7yJ2RYys3k8Rh6Gd6HIz4s4ZtWXyE2S2Cs+sp8LggmjZwEsAZv/swtYGl34XDdMnczPm9w28Zb6M66gkBhWX0iM5FopoYAIFQkz8Tf2dC68/u2PzJZcUnh2Q+BAQmh7mvEE2rbQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1730477692; bh=wTqxX0faMPZ7Ss1ADIwJ6YksEaqulJSJV1n7rScQPBW=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=F4vdrJDlEtQpSS7OcIPfEjORcRRRg6YnvwkBgBfq1JUzHa145WEJP34eaAQysPrKI5eZ1LErnD50HBMO3EvjvzcXbhCmf/ftJLXSYv6Q9jBu1h29vp3yQveLraAp5wAOah9TTQr7z8PcTOlAIo0vYQNuY71q9BpFUNClklJpYPUa3j4cd5R2zgFLd3b+jzyVek4YuImRc/TWpl7vTfb93HotEAbBOFx1qvxDvi3TXAjk18PMAWk0GPhj31ekKE/EZSLKt2cCWum6UwezZxTP95X50pbxqMbS+PRAzLXPtUsUdg1Oeab1p7yljAGSYOPuOIC3+oAt0KsOJhC9kdz+TQ==
X-YMail-OSG: 1iwE8ucVM1kK.SQDICZij1S86Z14741UOMwb3j.3qNm3Yzto004hqSWFTkHb5OR
 UAqURU0cxrKGiEM.gklulFQkn44Er5twRP24vECoxahYdNRdFCRRZqySURCdHL2bklbcCEjR9HQ2
 ms.3E3QvmMQkBDwmXjxkEJDj4K2dNbQ2Jco6p.RCB7EWI3Lr5Bq2rqQAzzys5QYt8uRSG2yCHh6F
 J6m1LlwR2Jx9VvVCrEzMIj3dW1Y8J3lrbgjNvjDS65i3.DScqj6fZ.m4JlHTWWs9MDYLY6Q_rxZS
 kX.HxNKOEfX62YMntvhY9g7fy6rWkoMCuNnjIK_wWFE_O1U3vFjDN__dw6nv2ko6RMkb3fxjnRto
 _9GPAZzBMvcFqJpxrswdGMZK6qW8m69P0gtfcFpdt60LYKEfmy36JN7eskBgEtdjg5OXVC2Bskv0
 shCw_rWsd00ROKL8Tj63spuieQpZtiwEAXzN2GGkDhSry.PsYyTOo0oEHXkpaAIR5QYZ.iACCsdT
 FsCXlbfOOTmzrlupkTe_.oaCtXM69rLR.pKwETIhv7oo0c6ekW7f8at0bVD7ebPOM0UqNcCP7p_m
 .7k5NwoAM8Gik9nT9S87rZqk4c957weacgxtJUKOA57wlBTNVJJ8p7a.CYJNdOBcGC7MUH5ZSGtT
 Fxw7Cvz7jwjqun8I76_0J87oZmKFNcgL.EusDEt_uzleFS22sOwuy_8xKwefDzpdMoM9cEUg.7nG
 LyTF8jaG6nB_OcY5TYE8O8GuXzsL64MlLVenfDVObOnePTlo6xc2ut1MZNdEk5HxTNgABmb4SyRt
 VyKd8bHrCFjwd8CcsS9KH6GjerTyn_35k5nJRcGPLqGItC9q69mvYcXRLEjmzpe_SW9_3F0E36N2
 A77Jfcm1dYgw.MDGbydZMj4s1MQbdxMXjvXd7h3efHIbKpK8.i3dPHf0lsQdVF1z42bGol_5YUkf
 uAewPdy.aYsJbQzEpKLwBI1KOIzqb896Ayc0Oc1Rh4qZfRgBp5tbXS3Xfh6YRmOR60HC5zA.doEk
 5fIMZc_JAm3EfoGRVi5rQ1fOREyh5j0FG6DJX0pnZqzB8o2BOZo3fQt1JSAv50JkxNqq2t_sQsx9
 bCzg.f1Znc8aVbyECn6weeX1n678DWjxDOuXijMJ4cb.durFiDeFbnvYPl1ue.lwQUMncwBDHKmZ
 jWKoQ415El0F8Q0lnH_iWb97nXFmj998cQu382q_WGjFUi7CUVVYNz3CEpb42h7MFYWxAen4ONdj
 NekzyzIukWrACh7uQI0dg7QnSZRsYv1JolraKYfdjsSDS78uTuVFoT50SWW.EB0ZjcVkt_WNbkiQ
 nZbQs31OvEmsB6fPOLyhn3IeFbSuPZNKhVRhhKNIOVwEfO8Rh.PfSG6GOQKAE5DhRRUF62GVbB9P
 JOKBF_qqR.29H6pqB2hO1Dle3VMk4sRJV7uVfUu2FL9FrCtiiENVyd5ZtvO5oUQNNtTgcGkEejPJ
 Dl5IMu1OK8y9VD6X1602t7HWM_17sslh2_dRyjOUhX45T_qmlbiI.Ukp6Wg12YSX_ZTcVa432vU0
 GBYzKmXz22rDBo1Aivk0ssU76izm15CvdGGFSBeaRQciFT.cm97Y17IXxIydzEDu5WFPmq6NqMPl
 TyfNy3tjELI7QSFvB3xVqTOaVaH4vl3Z5e5oI2OwZDca2qx.AITnt.ZvddKowqjDXxEUWmtfyKJM
 eOPv9al67U9C.TsZ7ytPS1t50VFdEKDFuCMLyV_XOy7z.otsbQKM0gG0CVvYAqOByDPyhaWxoEST
 Q9t8SfOdRKgo92OidzpP8wP8Ih3f0g.hjMuhBCy8KrAwMDNiErA4FWDDy0oh67a5.mMII1jAujpL
 QTyWBUFuwyXGxfZr0anT06gmVXAnZLL4McWo8Mp3e6DUEhPWDc9fBHb8UVt934DizGB2s7m_w.9e
 hFKD91CM07ZpX5dQMcS0qQ43XdaPHs5iB7rcDqo1vUK2XmReW5IQWRDIl6f1uua1hr8IRJS9Yvp0
 ZpLbvdI_z4Sv.45oopd9H9YolVyKYHkUibcKA9UEaViRv5dxVbnlF3G504pi4JMZJ6gZIwL4OxGI
 RAcW_pmDD_IxQBiSMlPGmxZTMSX9qEQeNGqIeMiOjSdMuCfFmyXBU77WQO1aTVrQHkiMNMJRKTEg
 IXlbok_Efhu22ggJNkd7aBJaZY8jPJD5CGhZWEWyABlneAh9Y2lyoYxUpdqUvU1Znf4mQZX4rack
 AZa5whkoXLWl0jzaxN8GvwCLqJM3fxHMePDXJ06ldBxtbuGihpT9.RmvyhWhNnJrBo4kWj1vkHhV
 eqR330NX1d8oqokGFCyFMvFjfeW8-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: f2232fa5-43ff-4dfd-b0d4-b05a3d717f03
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Fri, 1 Nov 2024 16:14:52 +0000
Received: by hermes--production-gq1-5dd4b47f46-bxhh2 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 01d3a5e9c667feb2527f045654b96970;
          Fri, 01 Nov 2024 16:14:45 +0000 (UTC)
Message-ID: <6a405591-40c5-4db6-bed5-8133a80b55f7@schaufler-ca.com>
Date: Fri, 1 Nov 2024 09:14:42 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] LSM: Replace context+len with lsm_context
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Paul Moore <paul@paul-moore.com>, linux-security-module@vger.kernel.org,
 jmorris@namei.org, serge@hallyn.com, keescook@chromium.org,
 john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
 stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
 selinux@vger.kernel.org, mic@digikod.net, netdev@vger.kernel.org,
 audit@vger.kernel.org, netfilter-devel@vger.kernel.org,
 Todd Kjos <tkjos@google.com>, Casey Schaufler <casey@schaufler-ca.com>
References: <20241023212158.18718-3-casey@schaufler-ca.com>
 <68a956fa44249434dedf7d13cd949b35@paul-moore.com>
 <ZyQPfFvPD72rx4ME@calendula> <ZyQRgL_jWdvKgRl-@calendula>
 <dd727620-9823-4701-aaf1-080b03fb6ccd@schaufler-ca.com>
 <ZySCeoe3kVqKTyUh@calendula>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <ZySCeoe3kVqKTyUh@calendula>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.22806 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 11/1/2024 12:25 AM, Pablo Neira Ayuso wrote:
> On Thu, Oct 31, 2024 at 04:58:13PM -0700, Casey Schaufler wrote:
>> On 10/31/2024 4:23 PM, Pablo Neira Ayuso wrote:
>>> On Fri, Nov 01, 2024 at 12:15:16AM +0100, Pablo Neira Ayuso wrote:
>>>> Hi Paul,
>>>>
>>>> This patch breaks nf_conntrack_netlink, Casey mentioned that he will
>>>> post another series.
>> I have a fix, it is pretty simple. How about I send a 6/5 patch for it?
> No idea. I don't know what is the status of this series. I would
> suggest to repost a new series.

I will post v4 shortly. Thanks for the feedback.

