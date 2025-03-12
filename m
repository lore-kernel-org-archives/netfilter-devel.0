Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECDB23DE80
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 12:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741782024; cv=none; b=hhu58OP0CdZAq53UlZPdMtgts5qVkyXJnFFLRqVRkcSKgsVPY5TqxvvnfQJs3Yp4DcLbJxMgdFPDTdEgeWzIwECRcw5f8tFGORwq6JQAEQZWB3DJH85KQBPweRkrdjHj07qRS9i8//QrDc4i6ZRxEP8ko1k8+ksPjENWn0dxLJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741782024; c=relaxed/simple;
	bh=ak0XxbkkfczaMq4LtT3fsPXKZk6J+oa7ETsWhnH00zI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F4VlYFB2Bw30EBRZPhZUPlR0CIgoSQpCp5qT5NUsojj4NWNOp9q2QaPiDZxPZI8J7dkputioDbK96uabiFNz0hOsrydo19Jd8k23yOdfA2aM724V6iSrAsaTc+G/4qN7gEoPiDYcLiewnARSl2NE9Qev98nqAT1bX3ljObrDJ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=rnZMQL1r; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="rnZMQL1r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741782019; x=1742386819; i=corubba@gmx.de;
	bh=cjBy788+74f9pBT7MNUK2jthmqMcXSsH3PL545XbEUw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rnZMQL1r9CjepJCv4CwjpVDpOQKGaiW34hiD1hGv0xn4yCrh9v8wUyZmQ9xwmClT
	 AwfdoO9Lpwx0lRV5eFbl3DSAT2P8w+BoGnWnrbgeThJGdk784VFri2ZPOJU1hkDaN
	 f4l7a/RSzZHG0xnO1PbGxKWQZzUMoVTAfzJRkxAguTMCh/8FzZUwp380OhXeQ2j8j
	 klIYTN1xXg7ftVhzVSuERcGVjUKHMiYU3p115RuQb4spvbR61BzHth2rMgdHVICK6
	 HB86SBkNqiiXM4HdZS92WFjy/aK6AsWhMIgpHHeSFO8pRyJk+SuRHxDUKMyr/bm4X
	 Kz7qhz6WEOSIwswWHA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.254]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MBUqL-1u4fYC1F43-00EQ1x; Wed, 12
 Mar 2025 13:20:19 +0100
Message-ID: <cd856fe5-2070-42c5-990f-8879d04cb731@gmx.de>
Date: Wed, 12 Mar 2025 13:19:58 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ulogd2] nfct: add network namespace support
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <7d1478b6-ec25-4286-a365-ce28293f4a40@gmx.de>
 <20250312083716.GA14222@breakpoint.cc>
Content-Language: en-GB
From: Corubba Smith <corubba@gmx.de>
In-Reply-To: <20250312083716.GA14222@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:J0X335txETvjh3v1lW9dDktWziLNAXMciDoIiAwwC98FUi2DSkN
 iUR9VSw8eVkjd0Nefp48JH1IH0rL7qibnNqm5JG7AXjXZfEPKtCcGpmPaLbwhJo9ZI368Jm
 mOy0RQI+B038z6bNuIncjjDXhgs4Vs2fLbEquFWtjzxZHO0+eu9ymCSquRIjtFr8bjrjWjh
 3jXzZbhKnSCLJ3+rdEBOQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:tDXM/bA2WNQ=;Axjjtkx8ufCFMc7OEcYb8MO2lzY
 qidbfulszHxW30LLVOCv9y1IuL0BtWBsLXkV25Oto4yjBlz2XcwHcpAIKO8+xsuDj9eco6qIc
 z8b4xe+sEKfC7s7060pq4gBWxaLSsdkeu3j2E9tClkKez3Y19gANMTV4QvEA/S+LJnHqkzRnC
 M6vKHYIkkl+hnQNHgR25WJt5fhlej/YeN/6Zm4oJ9D1EtvBffHqBhAsg1hjFXj3WffdjJysPh
 3ojRUm8kL/pAocfygmpPVsFIarJNJ4ABz5sNPPtDpPW/Sv1AvLy2wf4+Ua4LbahpT9+qORXCQ
 eyicRohr0ZpBU3dOORVgYigqJYidbv82ars+JcDN7B46oyog+3/Cyo2mQkNkXUUxZvJf10y+a
 CbLT1eR05cmSTzKxBQvQSrxkv70kDfzr+aUWbxvRIT2lO6TPDTxOj8e6buhak9sbkyK7JxxrA
 NM3Q7vBCeodQK5//FPD1sfoYbqsp9NGHvzbDHmGaFMEBpKn2lxfSJFoJ5ZlM5r9y1fe7744lZ
 x/8VftXjanmzlOu6BJOXUX1xMOYLI7Ll+qJD9kBA9zJBKX5LlNACNJ1D3wH0ifJmHEgSWt4U2
 EFA0q5Fe/2DefLTOaBShx8d/gNXWyioUv41EvXnkoiDYtELbI/S9/NGh9CdV4KL3yYolwEzTh
 eeobLVgioJiym4wptgfcFWj2AWhmQKhEIPebBVxqbo+orXAe2ZGyzenAda/WgLFN9X8e2a6fr
 FaNlVu+AkxovuxXr7AHdkrQU2BQLEmGa7Sto7+i8Tf0Ey4yQWQf1zuWp+/qsLvgjDUlCsVyez
 bcejPFZxB3LNfZyJBfvyi31oLBPRpN8BMsM8sE9Xk2x9N+BI453a2b36uay2HB38k76VSk4SD
 YnMZKlcPn/ehVTQCPkZLbtUINgCyfAmIE838ue2XUSyf7tbqSMQjfvT+vxW2TD9vq7cxalNYN
 wcwP5oGXiSQHdwPa7coNsQftY+mwlMfcO28nxBdn4gue4q+JVk42LC/eHBKMMDdq7ri7cv4Jr
 iNw3G258XIRs/W2/i2acW28C1oeuzlbC+t+vG60EiMFdqdFu1EutTyKUBm1X97OPH+C2IqlQR
 AqLjDF/cYbvsrWniMr8qug2Xu0ObAIA4zMadUrgFWmKPL+qazc749BHSl1yUiU+lRbEvn1vVl
 konUiNqklfmCKUBSBtdIUeTpmIXbmRwkZSc3c2QBSLwgGW8teHH1Tn4ggYjTc/ZpJAOsc60rx
 zMshF0ep9kiAiXP5RVe7tlodgV6PZ+GfftWWUfYITz2ou2xdMSijU6mn/04VI6wVs/6Ec7dR+
 Cb9JyRtnvJ6QGyVesPLe3FHG1EkWEImIkKfDcRDQ6DdqNOQZ+xX+tOSZOkMg2DHTOXT8kn068
 xXiT4lAqKFOOZGJ8o2sHkqMDKeTyv4Jp0OvkD4JGesaYPkbTXiJxAHBJ1K/zg6aQnPwd6J5Hr
 lY123DWHc5QKJe45ZYlLxJ9jOutd/5SYi9fYLRY5b5jHL5iWG

On 3/12/25 09:37, Florian Westphal wrote:
> Corubba Smith <corubba@gmx.de> wrote:
>> Add a new option which allows opening the netlink socket in a different
>> network namespace. This way you can run ulogd in one (management)
>> network namespace which is able to talk with your export target (e.g.
>> database or IPFIX collector), and import flows from multiple (customer)
>> network namespaces.
>
> Makes sense to me.
>
>> This commit only implements it for NFCT. I wanted to gather some
>> feedback before also implementing it for the other netlink-based
>> plugins.
>
> Does it make sense to have this configured on a per-plugin basis?

I honestly don't see the usecase for it. Enabling namespace support
depends on whether the used libc supports the required syscall, which is
the same for all plugins. But even if namespace support is compiled in
globally, you still need to activate it per plugin instance by setting
the namespace path config option. That option is not mandatory, and if
not set the plugin will behave the same as before, opening the netlink
socket in the current network namespace. So compiling in namespace
support alone does not change the runtime behaviour (or actually use the
syscall), it only does when you also explicitly use the namespace path
option on a plugin instance.

>
>>    Input plugins:
>>      NFLOG plugin:			${enable_nflog}
>>      NFCT plugin:			${enable_nfct}
>
>> +#ifdef NETNS_SUPPORT
>> +	if (strlen(target_netns_path) > 0) {
>> +		errno =3D 0;
>> +		original_netns_fd =3D open("/proc/self/ns/net", O_RDONLY | O_CLOEXEC=
);
>> +		if (original_netns_fd < 0) {
>> +			ulogd_log(ULOGD_FATAL, "error opening original network namespace: %=
s\n", strerror(errno));
>> +			goto err_ons;
>> +		}
>
> I think that in order to not have copypastry in all relevant plugins
> it would be better to turn code in the NETNS_SUPPORT ifdefs section
> into library helpers.
>
> The helpers would always exist; in case ulogd2 is built without
> support they would raise an error.
>
> That would also keep the ifdef out of plugin code.

Very good point, will do that. Thanks!

=2D-
Corubba

