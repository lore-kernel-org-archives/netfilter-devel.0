Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383A93B774D
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 03:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779767881; cv=none; b=CB4T/m9Ek0J6MWfg/cuvNN6Ia7Cm0h2Sd3Fy77thn1oBhzMcyhriasX86mswlRZGwgqkLHTmk9QIr1D/a5wEl8a3FsAnymnIH+vi+S3no0qC8HbLEUnNE1cGm+um/I6wQwH4k5a4//fAsvSpM91zkF52669HcX9sXInseRSMb6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779767881; c=relaxed/simple;
	bh=k2RJN2vsDYaulSTAz/8uNFK7JJ+D40fjGtgu7gmYmWU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ot0TKfd2ywEjrunHEQ0X9OvDjaIM7OKMoGZYjA9FsnT0RJQ9VoHTROInIdItOBOoDqrzJYdjlPKbns3iBJdxl5iShYP20ernPuP9PFH0lYiwZVW7T6gejYsUYdyN+DgV5tQun0lG6Axaza5wpBFnyn0DYFSyJrV1eYvXBnna5qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AC5Jttd3; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AC5Jttd3"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8b7f937ef44so65157906d6.0
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 20:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779767877; x=1780372677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zI0Orm1aZ2hutYK6WtttPlYR9+szr4UeRFDlWy1ys9o=;
        b=AC5Jttd3jxYNIYPeF+rSv0okXdVASPBQ0ZT5zuxMQPJ9ZjDYf2NTX7CVyRf8W7GAZI
         euajP3XyoHHQp9zZX+VUVHGWD4v/II1YD9p/+bFmFPoveOQj1Jw9eCpSGCjwgi0zzc3F
         EsPFC+ejZ9a00SMTAjydk8MyVbeC0vLYOzKwRmENsJ26oynCAW0VYGvCm2MuxU7ri8aM
         IWrqlQSZJD8wHRoIPRQS3g3LzsBF46hLCwxk7ToYGW7c4tDE7ZCjxFwgDngkY8KTtQvi
         dIBDY4MuOz61BGvjPzFe+WQ0Tk9eIU0QJNcjkEF4wvOt6GxBkzl8LdiM89RxWAsnbcIX
         gpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779767877; x=1780372677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zI0Orm1aZ2hutYK6WtttPlYR9+szr4UeRFDlWy1ys9o=;
        b=aOb2xdL0uy0RTYq2hGWPCbh/7fxf3jAbMKtI3YWN8DVJjxB9fgeVOtHcuknJqme3AK
         Ej9orTOtwa1akug4HzSVP8Zv59i8oBPYrGjT+lCzogADwUicc9c4zsZcHGsovxLx+UnO
         OJCc0j7uYaFxbGLsXgrJRRNDYkL5J1wziYtXSi879tsnUZNZDAcT7OtBY3RQU94Mfd0u
         DW1XNoPI1ZVAURgwUg54LSCWvHZUaX9LCEUObdfiwGxnNP0m3U30aGOYuZrGG3o3UvDK
         PyZ8TNTChvq//d6NJdk9nliiYu32ryZOU7kFi/DDuSr1y8DobLThKaWUd5AZj9M7NOSG
         ImXg==
X-Gm-Message-State: AOJu0YzEL1y1cJbHTOSTsjZOHC0yQjAaYlqVhXhG6J0Xsx9ydJw67iz/
	Fd/xS0Sg9EUKQIpx5R3iwBRk51+iLEniJOjuXgCyyU8WB8fet9be40/OImuFl3CV
X-Gm-Gg: Acq92OFdRVpwUStgMg3XuoJFzpn+uvF82IeH43/ro7w2fVLAA72OPAsSxulyrXFu+Sj
	YrcYXk0/r3LazPDx91RVKVSDmZuh+DyxHf3Rn7lJvvVVR63Se9WqMybT4zviJYfExp1VB500GdE
	vdBVwuqhZxq13HLzzFKZOUtMdxKrTHoApG7cU4yIRcvnMNXzF44zZer384a5t8Fpg736Qblyk0U
	3aHFMDUBWOIfSuS0/gwz2ycKR4m4E+fc/PhFggQ0eobtFzsAe6OPQYmPBloYqr87CrsjGO5Pxdu
	p3t4hyjYXiXgaZZTE66RbGi0H1TLpa+0eSbeEydQZkfcHK1y5YkcU37HnvDKQuxVIxJIXL9ncU2
	IH7cReF+MFDOjacFsb/EtnT2xtwANuXrSyh3PsKkRkFA6rxeIYHZFz+dor8Wof6ahmJeJ8q/sZW
	9vsBSHksahqh3h38cDOJb1xFS/tqs=
X-Received: by 2002:a05:6214:410b:b0:8ae:6460:c550 with SMTP id 6a1803df08f44-8cc7b5cf73dmr295213056d6.36.1779767877154;
        Mon, 25 May 2026 20:57:57 -0700 (PDT)
Received: from playground ([204.111.226.76])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc812df29esm130884796d6.29.2026.05.25.20.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 20:57:57 -0700 (PDT)
Date: Mon, 25 May 2026 23:57:54 -0400
From: <imnozi@gmail.com>
To: "Kerin Millar" <kfm@plushkava.net>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: ipset not completely working in mangle:PREROUTING
Message-ID: <20260525235754.4943a2b6@playground>
In-Reply-To: <a276ecef-e609-4d55-bc71-ddb9c9ff2f3c@app.fastmail.com>
References: <20260525205736.1c76666f@playground>
	<a276ecef-e609-4d55-bc71-ddb9c9ff2f3c@app.fastmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 26 May 2026 02:57:38 +0100
"Kerin Millar" <kfm@plushkava.net> wrote:

> On Tue, 26 May 2026, at 1:57 AM, imnozi@gmail.com wrote:
> > iptables v1.8.7 (legacy)
> > ipset v6.34, protocol version: 6
> >
> > I have four sets:
> >   - blockSetHost (hash:ip)
> >   - blockSetNet (hash:net)
> >   - whiteSetHost (hash:ip)
> >   - whiteSetNet (hash:net)
> >
> > I added rules to match the block sets in filter to INPUT, FORWARD and 
> > OUTPUT. The rules match and jump to chain blDrop. In blDrop, if either 
> > white set matches, control returns. If no match, the packet is dropped.
> >
> > This works well in filter. But there's one artifact. The blocked 
> > packets are 'accounted' to the internal server where they would have 
> > gone.  
> 
> The meaning of this isn't altogether clear. I presume that you are referring to counters in some capacity.

'In some capacity', yes; setting connmarks to identify types of traffic, then using those marks and '-j ACCOUNT' with specific tnames lets us have a nice CGI page with bar meters that cleanly displays various traffic levels, and other 'reports'.

> 
> >
> > To fix this, I added the rules below to mangle. Here in mangle, the 
> > white sets never match and all of the packets (that matched the block 
> > sets) are dropped.  
> 
> Be sure that you need to match on the NEW state. Otherwise, -t raw -A PREROUTING makes for a less expensive way of dropping ingress packets at the border.

I've been matching only NEW packets, letting ESTABLISHED conns close themselves. Later I might add rules to catch ESTABLISHED packets that match the block list but not the white list, then hit TCP packets with tcp-reset and all others (blocked) with icmp-admin-prohibited. (This method does work well to shut down conns instantly: "None shall pass.")

> 
> >
> > Is this another instance of 'it doesn't work in mangle or in PREROUTING'?  
> 
> This is unlikely. Both -m set and -m state work in the same way across tables, though the raw table precludes matching on conntrack state.

OK. So ipset *should* work in mangle:PREROUTING. Can the same chain name be used simultaneously in multiple tables (though if not, the pre-defined chains shouldn't work)? I'll experiment some more; I'll even try specifying state NEW in blDrop even though only NEW packets get there. I've been blind to mistakes before.

> 
> >
> > Thanks,
> > Neal
> >
> > ----
> > The rules used in mangle; eth3 is internet:
> > -A blDrop -m set --match-set whiteSetNet src -j RETURN
> > -A blDrop -m set --match-set whiteSetHost src -j RETURN
> > -A blDrop -j DROP
> >
> > -A PREROUTING -i eth3 -p udp -m set --match-set blockSetHost src -m 
> > state --state NEW -j blDrop
> > -A PREROUTING -i eth3 -p tcp -m set --match-set blockSetHost src -m 
> > state --state NEW -j blDrop
> > -A PREROUTING -i eth3 -p udp -m set --match-set blockSetNet src -m 
> > state --state NEW -j blDrop
> > -A PREROUTING -i eth3 -p tcp -m set --match-set blockSetNet src -m 
> > state --state NEW -j blDrop  
> 
> An iptables-save -c dump would be preferable. These excerpts don't unambiguously qualify the containing table names. In particular, there is no way for the reader to determine whether the chain named "blDrop" in whatever table that may be is acting in the same way as the chain named "blDrop" that may still exist - or have once existed - in another table.
> 

Those four rules in mangle:PREROUTING are the only ones that send packets to mangle:blDrop which contains the same rules as filter:blDrop.

I logged into my external VPS and ssh'ed back; this worked. I exited that session, added that IP to both the white list and the block list and tried to SSH back again. Neither counter on the white list checks increased, but the DROP counter did increase and the SSH connection was blocked. I then removed those rules and the chain from mangle:PREROUTING and did the same again, this time watching the counters in filter:blDrop. This time one of the white list counters did increase and the connection went through. At first glance, it looks like the set match didn't work in mangle:blDrop.

Again, I'll experiment some more; maybe I missed a special incantation or chanted it at the wrong cadence. :)

If you want, I'll send you a complete 'iptables-save -c'; it's about 800 lines. Unless you want I should pare it down some more. 

Thanks,
Neal
