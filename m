Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088591EBA19;
	Thu,  9 Jan 2025 08:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736412984; cv=none; b=atQJzTAF3SP2U2+DayLN6z3TUdZGTctcjiF1Dp4iO5TI/pUSUvNfExgA26r4W70qIjaNRbyIrnYymYOtMyZyDK6u/jI9Qfl7y2vvMt0O4ZN/vLHmCEq2nB1mwLk0OgtS02470ZEW4TRmao124Fu2gDwy4DaFd2+8yE254dngoik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736412984; c=relaxed/simple;
	bh=wp2CVqXaTLMEhu/P0gxP9vMepAcXofaZ9f1o56WSI8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lWTUiwh0wOk/yNo14JL3YFwMP88B1dt8/b2Q/4hQPtOCAXHOr38gsV24xZ5C0xgLNoQFlFaNX5+kSTH4vS/kZqcEAo92i37H8NmKgR0OihQdn9ifs3xQ3mH4W6Felm6gs357PhTFmhysJxpbD8D6+hGHpBqs55yuPT24NPEMTzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F21auoWG; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F21auoWG"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa69107179cso152561566b.0;
        Thu, 09 Jan 2025 00:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736412981; x=1737017781; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XS6TlRWyTSRfC4D8CM7324D8iXz+6nRl08PCaLYh1SA=;
        b=F21auoWGLzJ75oTsQNwogo9Q1Z7NQwCDd+jEQZ0bETnBK0Y2aJMGL4pqbb7W54R7Hs
         F4JOnCTBMKfWvzuwz5Vi6kS5jQPgSpNA7EFlhSC2ZcIk0DQDspvz3b2neMufkaT54pVq
         58UmRUThCDovoiKWFXbh0vazNP1jmYgXR6VaYEIPJimRPLNJNylmBtqNE2qX2l0nQVbE
         eSf5ZbtLpq5rdvIUct47BTLDQ+hf7g/yl7HnUfFihidGodFdeRAttHijABU7iv9QVOJ3
         lPJnXfAsCshA8HmiYlZ++JIgPZBuPHKfLvMi0drjicyPhTD2Zj3WJ6YRCuISR/gQaQGf
         bddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736412981; x=1737017781;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XS6TlRWyTSRfC4D8CM7324D8iXz+6nRl08PCaLYh1SA=;
        b=idcpyyIzeCr1H8HDhSCKkmFlq5dT37sGDzEnYBcwbzL7vxLLAKZl8i6M8EZ8dpMexx
         VUsRnJRKb+klS1aTp1djw4h4OCpRKAA4JfgrcdB8jJg7LjdRuRbCrKmpf0TXAqDE2YwJ
         tEdCMWpE83Xf82C4jmwcK3x3odYSAVAuyYn7SwsFYALMdWq8dcCYszNkKsVGRWNtFVrD
         23/p2QBefGYxz0AHKssdB8fSenwM8+cknhGxahPeZ/z8x4GKkZCWxK/5uDITWTV8YwZC
         28htqB21lyqMw+7mWdN86manqhXeNdMUjFHxtZH1Du8yZ6VvM/E/+58bSTRXGVFlWUf2
         LvdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFhGPBdSz0V3lQWtMPE0+4sgymWwELv6y4QncVYYmb85ziygv6TGyOPMAmcivQzxFo8U5by3HIwdwkQL8=@vger.kernel.org, AJvYcCUHsE6pES2A/6/tfrqoP5+ekwUcA6YHV1/ofwLrKJQf9c+Tc88ESO4jGi3CWJUUdue0yFoBlqKBbdQDIfRvzhPa@vger.kernel.org, AJvYcCWxXNuklEBV6ATOJngkncuwRyExkvxTLcbNIb+Aif8CCiSW+bxDSGZJ3HUVDS5pNbBsA3hUNR6r@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv3b3eepqKJR6+lrbQCK3cZRuiXB/sEIf+RRhzaPQODM4dtvJV
	LgLjlLUYZatBU6/9/OB2nW9rtHNBNYZi3P7KKey6iivC99hvycMH
X-Gm-Gg: ASbGnctWLfj1Vbs9FdW143Uk3An5e9dEr770wGOav8J/V88FT7RyHWO10U1oC3JPMlE
	d7uVtNiOpPxFZZgf4dQavEx7rWpyaLXNgephCIodUPhLa+4p3WBikB7mPRVAx0IYN5YQ3RHdfep
	bEMW+9U1fesZCxn6hsGwbNAtCdPqh9v3rLGcSBKZ6x0chbxblEEDC4hHPbvEIz4xPEdpau7cmtl
	+KbxdrUxfzSWehiuk7jfBnK3Ahy+0dPkI59qGmsp1MAKh5qHDzRkUDU6wVW0MXn34Q5ELDqJmYP
	SNOLv36fNtVt6EeHxb+iDpcpQPW40wIHBQbMLdeio+k+w69oJLMOY5vHKsds9mmJKMmczmsLThO
	yNfHWlAGaAMitm4dwMth+WYAW8f7w60o=
X-Google-Smtp-Source: AGHT+IH3My3UUh3xFM8ZgIgF0aWMNmsqTttAtJxwpSIcvfI0XILfisWjLOFCeDXh+SXgbl3J8Hxz3A==
X-Received: by 2002:a17:907:3e24:b0:aac:2298:8960 with SMTP id a640c23a62f3a-ab2ab6fcf7amr446231766b.35.1736412980929;
        Thu, 09 Jan 2025 00:56:20 -0800 (PST)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c9060a4fsm50179466b.15.2025.01.09.00.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 00:56:20 -0800 (PST)
Message-ID: <98234080-946e-4b36-832f-113b185e7bca@gmail.com>
Date: Thu, 9 Jan 2025 09:56:17 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC net-next] net: phylink: always config mac for
 (delayed) phy
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20250107123615.161095-1-ericwouds@gmail.com>
 <Z30iUj6DE9-fRp0n@shell.armlinux.org.uk>
 <4b9b2a9a-061b-43ad-b402-a49aee317f41@gmail.com>
 <Z31CJS1YUvPGiEXs@shell.armlinux.org.uk>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <Z31CJS1YUvPGiEXs@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/7/25 4:03 PM, Russell King (Oracle) wrote:
> On Tue, Jan 07, 2025 at 02:14:03PM +0100, Eric Woudstra wrote:
>>
>>
>> On 1/7/25 1:47 PM, Russell King (Oracle) wrote:
>>> Going through the log...
>>>
>>> On Tue, Jan 07, 2025 at 01:36:15PM +0100, Eric Woudstra wrote:
>>>> Log before this patch is applied:
>>>> [root@bpir3 ~]# dmesg | grep eth1
>>>> [    2.515179] mtk_soc_eth 15100000.ethernet eth1: mediatek frame engine at 0xffff800082380000, irq 123
>>>> [   38.271431] mtk_soc_eth 15100000.ethernet eth1: configuring for inband/2500base-x link mode
>>>> [   38.279828] mtk_soc_eth 15100000.ethernet eth1: major config, requested inband/2500base-x
>>>> [   38.288009] mtk_soc_eth 15100000.ethernet eth1: interface 2500base-x inband modes: pcs=01 phy=00
>>>> [   38.296800] mtk_soc_eth 15100000.ethernet eth1: major config, active inband/inband,an-disabled/2500base-x
>>>
>>> This is indeed without the PHY. We're using inband, although the PCS
>>> mode is PHYLINK_PCS_NEG_INBAND_DISABLED, meaning inband won't be
>>> used. As there is no PHY, we can't switch to MLO_AN_PHY.
>>>
>>>> [   38.306362] mtk_soc_eth 15100000.ethernet eth1: phylink_mac_config: mode=inband/2500base-x/none adv=00,00000000,00008000,0000e240 pause=04
>>>> [   39.220149] mtk_soc_eth 15100000.ethernet eth1:  interface 2 (mii) rate match none supports 0-3,6-7,13-14
>>>> [   39.229758] mtk_soc_eth 15100000.ethernet eth1:  interface 3 (gmii) rate match none supports 0-3,5-7,13-14
>>>> [   39.239420] mtk_soc_eth 15100000.ethernet eth1:  interface 4 (sgmii) rate match none supports 0-3,5-7,13-14
>>>> [   39.249173] mtk_soc_eth 15100000.ethernet eth1:  interface 22 (1000base-x) rate match none supports 5-7,13-14
>>>> [   39.259080] mtk_soc_eth 15100000.ethernet eth1:  interface 23 (2500base-x) rate match none supports 6-7,13-14,47
>>>> [   39.594676] mtk_soc_eth 15100000.ethernet eth1: PHY i2c:sfp-1:11 uses interfaces 4,23, validating 4,23
>>>
>>> The PHY comes along...
>>>
>>>> [   39.603992] mtk_soc_eth 15100000.ethernet eth1:  interface 4 (sgmii) rate match none supports 0-3,5-7,13-14
>>>> [   39.650080] mtk_soc_eth 15100000.ethernet eth1:  interface 23 (2500base-x) rate match none supports 6-7,13-14,47
>>>> [   39.660266] mtk_soc_eth 15100000.ethernet eth1: PHY [i2c:sfp-1:11] driver [RTL8221B-VB-CG 2.5Gbps PHY (C45)] (irq=POLL)
>>>> [   39.671037] mtk_soc_eth 15100000.ethernet eth1: phy: 2500base-x setting supported 00,00000000,00008000,000060ef advertising 00,00000000,00008000,000060ef
>>>> [   39.684761] mtk_soc_eth 15100000.ethernet eth1: requesting link mode inband/2500base-x with support 00,00000000,00008000,000060ef
>>>
>>> We decide to use MLO_AN_INBAND and 2500base-X, which we're already using.
>>>
>>>> [   40.380076] mtk_soc_eth 15100000.ethernet eth1: phy link down 2500base-x/Unknown/Unknown/none/off
>>>> [   40.397090] brlan: port 5(eth1) entered blocking state
>>>> [   40.402223] brlan: port 5(eth1) entered disabled state
>>>> [   40.407437] mtk_soc_eth 15100000.ethernet eth1: entered allmulticast mode
>>>> [   40.414400] mtk_soc_eth 15100000.ethernet eth1: entered promiscuous mode
>>>> [   44.500077] mtk_soc_eth 15100000.ethernet eth1: phy link up 2500base-x/2.5Gbps/Full/none/off
>>>> [   44.508528] mtk_soc_eth 15100000.ethernet eth1: No phy led trigger registered for speed(2500)
>>>
>>> ... but we don't see link-up reported by the PCS after the PHY comes
>>> up. Why is that - I think that needs investigation before we proceed
>>> to patch the issue, because that suggests the PCS isn't seeing
>>> valid 2500base-X from the PHY.
>>>
>>
>> I think it is because pl->act_link_an_mode stays at MLO_AN_INBAND, but
>> it needs to be set to MLO_AN_PHY, so that only the phy determines the
>> link state:
>>
>> phylink_resolve() {
>>     ...
>> 	} else if (pl->act_link_an_mode == MLO_AN_PHY) {
>> 		link_state = pl->phy_state;
>>     ...
>> }
> 
> Please see my reply to Daniel. The PCS should still be capable of
> reporting whether its link is up or down irrespective of whether
> in-band status is being used or not.
> 
> While it is correct that PHY mode needs to be used here, your report
> has pointed out that the driver is not reporting the PCS link state
> correctly when in-band is disabled.
> 
> Given that the current state of affairs has revealed this other bug,
> I would like that addressed first while there is a trivial test case
> here.
> 

So I've narrowed down the problem a bit:

At first state->link is set to true, while looking at the bmsr.

But because linkmode_test_bit(fd_bit, state->advertising) and
linkmode_test_bit(fd_bit, state->lp_advertising) are both false,
state->link is set to false after looking at the bmsr.

void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
				      u16 bmsr, u16 lpa)
{
	state->link = !!(bmsr & BMSR_LSTATUS);
	...
	case PHY_INTERFACE_MODE_2500BASEX:
		phylink_decode_c37_word(state, lpa, SPEED_2500);
	...
}

static void phylink_decode_c37_word(struct phylink_link_state *state,
				    uint16_t config_reg, int speed)
{
	...
	if (linkmode_test_bit(fd_bit, state->advertising) &&
	    linkmode_test_bit(fd_bit, state->lp_advertising)) {
		state->speed = speed;
		state->duplex = DUPLEX_FULL;
	} else {
		/* negotiation failure */
		state->link = false;
	}
	...
}

And I can confirm, if I change the part above into the part below
(removing the if statement), the PCS also reports the link is up and the
connection is functional end-to-end. Not that I'm saying this change is
the solution, only for narrowing down the problem.

static void phylink_decode_c37_word(struct phylink_link_state *state,
				    uint16_t config_reg, int speed)
{
	...
	state->speed = speed;
	state->duplex = DUPLEX_FULL;
	...
}

Also worth mentioning, up until v12 of the pcs-mtk-lynxy.c
mtk_pcs_lynxi_get_state() did not call
phylink_mii_c22_pcs_decode_state() at all for 2500base-x.

