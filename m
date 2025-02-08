Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B39244E8E
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Feb 2025 21:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739050235; cv=none; b=fnRaFDcaGPOoyUdjXMa6Ge9sGwcIue3yym34i4Zrd8gweUU0o5UMN8WlcPCBe3zddOArxek1GyJzh/GXg5yU9AytworFRt0Uw1wsVwTwKl06nL/6ECWR1QgV2iipZVR6FxI6V8BMF+Yir7fGKTZBdvGf6HHZkkE/Mpht01RJHeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739050235; c=relaxed/simple;
	bh=AnRe9keLHOwZj2K0n4M0m6KEVyVwkLOJ8VkfGHXS9ZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HWL1XhqtBeApZEeykfGv8seRrwsqGUpahA8diAdZKTgeIY2LcLmaWNS75zKJrx9b6FWGeSqEkAr+UI4k2rtzFkL9NU7x/uc12KW9vsVVLnu4QrRn3BAdyPPC3XMgqnDeyeCvjVjzEfGrXghnsLDf9ttnNyp+lDRagTzxnjU/1g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=fC2mJMoK; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="fC2mJMoK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1739050231; x=1739655031; i=corubba@gmx.de;
	bh=/gNiKtg/kd9k4tQFwDhxJwyrp1jFT2ZNmZH8xkzbgz8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=fC2mJMoKA1ZV0WOq4f6tBsA0f82BCgnxWIe4XHdRHe7IofjMNECXdrB56l5pJbll
	 ZRjNuM8krXEBIdRNW9XL12PRIYHskI4uRlepHb8lsisHlQHaVh7oxhA+1S8nDekNX
	 tGhjtvlIZgi2NBrXevtk4SkoG6CQAqdbCTWcAKQGmsoNhCaSRE0wFgOWJ5CxDWXCZ
	 wYhM9tyzN8I8LARQb1OkxKtofV/Y6PRyaj0fa0w8UJGIrmD+ZDsHKG+Tld7ZWA/LK
	 oJkeQr1duHmcmUQcRYWEhjR3KfZaYwxizt8LFLvPkXK21eM3EA/MZ1eQfvLOK1nTo
	 yNzVyrOwSwa8NQYlPw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.92]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M8hV5-1tl1Gg0F3R-0031rP; Sat, 08
 Feb 2025 22:30:31 +0100
Message-ID: <9a755bdd-c715-46e5-ad50-6e158ec1ef48@gmx.de>
Date: Sat, 8 Feb 2025 22:30:04 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ulogd2 2/3] gprint: fix comma after ip addresses
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
References: <0a983b51-9a51-47a7-bbdc-9bf163a88bbd@gmx.de>
 <2e047e50-e689-4fbb-ae58-bc522a758e40@gmx.de> <Z6fKoE-JOtvbKHvY@calendula>
Content-Language: de-CH
From: corubba <corubba@gmx.de>
In-Reply-To: <Z6fKoE-JOtvbKHvY@calendula>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:WlcgXyqn7sTFPLnhoW+PJP7/0HE9FH8kaSU/AAiWl6Pk9VoYg2Q
 DSuyiRTF0Urrffv1DZuX2Vv1YYSbY/vFwnkLJQxFlNMQrW5PEDJOdU0CllrhciW0YwVzFW9
 pXmTYHbhFMjCPKbIide6x0hER08on95V2x4ziBdtlUqUGoQAGOwFIoBMpCl8uaaaUmN/Ze7
 V0WhWBV7fMDjmGONDGIzQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:yQydQNgGwN4=;CSqIhm2946YRnPr+zwxmr2DXlzp
 l73/nsPnvvraET1Zul3Z4a7QJOE3VAndfD6W8QEkJY6pmYUw966eY+dnPJRQLgOxy4S3pEcR8
 wuecX+pGtjf2BovLoavJrJrRrFw9w/Q71QWS6h+xylQKbronZyNFmM9qu7RdNUG0Cvuxb0mWk
 jtppKJGmBFWySqDo2dZlttUMhXLHOmKCRVawSfpIlq+R7Ab+uAETQ9PashWmf7Eqpbq59onU5
 j/xMWFLXy+DGR82XvbwXaNs+cLCKCySHp8QVvL6E481Fp6q+JdKrqmFGphP1J1p3QuZ9pwERB
 ie0hdAuYXLZ9Ywp/c3H8M2jNM+TtBsbPoHT7gZbu8ClJtHeZywYciHANa9PWZ8dlVg4r1db96
 n0ndBgas+d7MfvQAo5etzxChoqZ7VdK7I12jHZ/7e65x1bCyUF5oBF/OAO8icUlQDd+3FgYRg
 W6IWT9Cl7qZ5+0OwdkB5F0zGXopXpPxtqSnDrAWnnQBB709ijRAEww0OUuU2IvTelz+FE7ClQ
 eYCnRL4BB559P/FT+qoKuu9Pkv2c7zHxa+fphebCqi9oUswQcg45zulip3Xad+pM3ILD6Kbie
 yV8xYV3ygMFo50GXWK3Xt4ex7s1wOhVqVMRkjpBaQaBHDGdN2Ro5ypLRo6m7xtsrS+NWD7VES
 Y11Qp36aFPcA1g53Msq0z5C3jf2w+DD5uMETqpFNhRGnzrh3BNHpD/6/lOc4eNyx2yZ7nk6yI
 qm65xPxOI5XddKPwZsLq9kgWnQH0BsWkxV6L8domnNcIgDA+NOhiNt8eYy0hc3yi9hxYPkgis
 NbijV0jPSZMOKlGskJAuNJS+H7fY1QFczaU5qfKmKq+ttdL9CPCHY4L7fHPgOY3zuv7TGuHkG
 FuI7eu1aYpLVP7FRKG0mwmP8sMAcepXBk4Sk+D8bi4hdUZdDNugUxiIHDFKi3+Kt2sqowpQJR
 PUF0SaZAmvC5P3VQko9wcrgQvgP0KUTT5o+3FPLk+im42zeLQppySrReXxZj1IyrCt13lXBaU
 QlL8n5aDSG+XOFFo3M7Ck7uptp1yq/72Y8TdWnN86xfWacZwzo0im8L2qV+piqn2z5DXQn6Nf
 pLFTixUrSAHI7QlB9l4uWr0r7F595oXVs73PfcdV5a6TYU9OZhKpSxVxG/yhGngVs4Ivj7LNV
 uqUdCBQvcqgZsJGwR6jaNRO05OoIZpHkSkUV3f7S5tmDxCZTtfcFFd7ti6u2c6qQsK7Qexm9O
 bieuNAsjGRK4SLtNpFT0tPhs9rSVw+Lb3DXDuT2k2S3tieOutM2/U5Tgt1nfOY2F/4CCR9G95
 biB5GN5Ymu9GMFhNTgudbOWgNRyjuhmYyDHCz4y/pPp0lilyf7c1NcHbc0EEuI11JxQgUTHA0
 3nqHbFOrZsP3iJBu2sGgsJdkJfaRF7d831MEN9yUsIUSHNZgZ7aj0d5HlpnRM89TENBN5Q9Dj
 mh1YhIQ==

On 08.02.25 22:20, Pablo Neira Ayuso wrote:
> On Sat, Feb 08, 2025 at 02:49:49PM +0100, corubba wrote:
>> Gone missing in f04bf679.
>
> ulogd2$ git show f04bf679
> fatal: ambiguous argument 'f04bf679': unknown revision or path not in th=
e working tree.
>
> ???

The full commit id is f04bf6794d1153abd2c3b0bfededd9403d79acf6, which
does exist [0]. And that `git show` command works in my local clone of
the repo, showing the commit in question.

[0] https://git.netfilter.org/ulogd2/commit/?id=3Df04bf679

>
>> Signed-off-by: Corubba Smith <corubba@gmx.de>
>> ---
>>  output/ulogd_output_GPRINT.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.=
c
>> index 37829fa..d95ca9d 100644
>> --- a/output/ulogd_output_GPRINT.c
>> +++ b/output/ulogd_output_GPRINT.c
>> @@ -179,9 +179,15 @@ static int gprint_interp(struct ulogd_pluginstance=
 *upi)
>>  			if (!inet_ntop(family, addr, buf + size, rem))
>>  				break;
>>  			ret =3D strlen(buf + size);
>> +			rem -=3D ret;
>> +			size +=3D ret;
>>
>> +			ret =3D snprintf(buf+size, rem, ",");
>> +			if (ret < 0)
>> +				break;
>>  			rem -=3D ret;
>>  			size +=3D ret;
>> +
>>  			break;
>>  		}
>>  		default:
>> --
>> 2.48.1
>>
>>
>

