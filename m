Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D12204F93;
	Fri, 10 Jan 2025 11:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736507572; cv=none; b=owBWu93SNP1DGPFupsSsaaWqXIag6ju5oBJb50RFD5v5bH7y0VyC2rQKZ0RfrewGvn6p+P5I+VCPv7x/Cd5nk/tdEahrXQsB9WeZZFi/N/9xlizYTvF7ejrCrt6l0WdNSkz+mJqJX8sNit8PlVBJ+z2OqEqaIV5Y1Ltm9dlGdro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736507572; c=relaxed/simple;
	bh=UeOt5R2P5GeHb8nFPEh954S2nl3+3csDNv4eH/iGYgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F5DTFc+VboHQudJHdzNFidJHd5kkec7d0J5Kt/Y7U4FocT0gc0COMaapTBbVl7DJ9o02irhmlTp/MZzCtx8PlciUijQdAiw1WBClTwHroVcOuhP7jrvobyPM8TNcE3iaLgqa0ttrMrJEWIEyWIfpVMx012W1c8eGliFbDVS3EMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QX6MbU4H; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QX6MbU4H"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3863494591bso1070745f8f.1;
        Fri, 10 Jan 2025 03:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736507569; x=1737112369; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=y+x9FB8gpRu+ny5JZ4ENzOnNmCE2Q/tjr8cqBXheLDU=;
        b=QX6MbU4HDVaBbMqHG+hWJSmYFgJmeoPSYLDxSSwj+cqH8BPwCcxc0t6+YyRuBEW0gN
         o3qpXMgA/6ROBEziDgi5aqXJXq5R2CvcVDQIcHnhL8aW2ti54TDM38qJ9GuK0aM0TSRt
         9y3DMhulU9eaJrcrC1YIPLrI83V/SPaop710lPwSRbY3ylDOUaAytQS08XykQNIPunZO
         j1/EdEr7Gge851MrpK5HSxtfAKaW0yV5LDYQ4Hi1MSrc/2Qt6m2Wag+Laq7Xx9X335bE
         s75Vm/mMVjVViLFe0MtkbTEmwQ7IQLPnpR1BYEIWHpUj5wcPoaUZ3RbmAIMHcCMjKYm1
         62EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736507569; x=1737112369;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y+x9FB8gpRu+ny5JZ4ENzOnNmCE2Q/tjr8cqBXheLDU=;
        b=o7Xhi1q/pZBTiANLHR2UEij8N49G+eMSCIUGplEG0NRjyKleZOfbwK9lD7ZCJK+6fU
         xRUCESa25ZHjr3eBj3ObIXkSvDam8gVV1gsGeqaQBPXK8tdMdqHvXPwFK4QQFvniYrak
         Sq2wxreHMJNfyo4S5lw9acmTzwIU5bRXdZhevHYMyPkBiiC/l8JMR6OdxQZsexsG8mRq
         AUeVhb/W1bWOEtgVbrN+buPz4+6ff7YlebWSGJDfrQenh/ag+jY4Ba/4LiC65NBoRLXE
         hCmFX8yoIHtf98bzXgA6yGO6Mkx8yktHtRINJXsIx1Xki8YSa9/yDi77JjRNPi7Kovof
         19Ow==
X-Forwarded-Encrypted: i=1; AJvYcCU97ksMh2xRLM0NYIjoWEltEKlGgmI3l2c/Oqu8YS4kOAzDmJ99+J01Fd7e6Z5UlMJQ8cEzsY8m@vger.kernel.org, AJvYcCUomSMONhTmf2J/cJVAZ1rFwP9086dXuSloT61eKlcagVHF8uwKx1CUcrRUN3LSEYnZkI+RW49c4LCV/Xb2wPvxOvcTksU=@vger.kernel.org, AJvYcCWI0twDAxHm/ORiQFgrQAbW0hPxfBUz4PS68j5CvfYWJ03O4mOCrx1LTWhee7Z+auYLmNZjgmdehtYoojyIPp4S@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8NxCLsL67VeketgYsqZWLJ0hQ0CJS3VJgTzkaWZrwfTAVdMFd
	hD0ji9I16gqlEH+tZMznCCIequHqZl5RjNam2gcPSpmpHfYawauc
X-Gm-Gg: ASbGncumUGXzpx3AS4tw6UOr8bBGgSzZn8eLdzyuVMDdj6PtwisKXxTjUdEUr+h5b1+
	0bVbwu7j1YreBf2ZHZdgOwiZ4QO2AB6f3cC4N9k/WeQRBYBoCt2hH99D8q7UZ13fKGMSZ+cKJvm
	pCH8XzPk/4xMJu39E9+hxVuMMSjHC92Jb48I/a2JGZN89MgxETzYDNCKdROmQdxsQIKPXywH9cy
	yjgUQllu8FsqFnT5BczrpUNMzQphMYpQwD9e6CeuJdET7Mx91n47GeROA==
X-Google-Smtp-Source: AGHT+IEgmiSksMHjPRzswCZRI9x/P5xOUcq0e2x7nHHa8Ps+XDO6PG0n5O7zc0nMyxeBvkMf1N/LTg==
X-Received: by 2002:a5d:5f85:0:b0:387:86cf:4e87 with SMTP id ffacd0b85a97d-38a872deb33mr10369275f8f.15.1736507568637;
        Fri, 10 Jan 2025 03:12:48 -0800 (PST)
Received: from localhost ([2a00:79e1:abd:a201:48ff:95d2:7dab:ae81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9e6251asm51588845e9.40.2025.01.10.03.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 03:12:48 -0800 (PST)
Date: Fri, 10 Jan 2025 12:12:42 +0100
From: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack3000@gmail.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	willemdebruijn.kernel@gmail.com,
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, yusongping@huawei.com,
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v3 01/19] landlock: Support socket access-control
Message-ID: <20250110.2893966a7649@gnoack.org>
References: <20240904104824.1844082-1-ivanov.mikhail1@huawei-partners.com>
 <20240904104824.1844082-2-ivanov.mikhail1@huawei-partners.com>
 <ea026af8-bc29-709c-7e04-e145d01fd825@huawei-partners.com>
 <Z0DDQKACIRRDRZRE@google.com>
 <36ac2fde-1344-9055-42e2-db849abf02e0@huawei-partners.com>
 <20241127.oophah4Ueboo@digikod.net>
 <eafd855d-2681-8dfd-a2be-9c02fc07050d@huawei-partners.com>
 <20241128.um9voo5Woo3I@digikod.net>
 <af72be74-50c7-d251-5df3-a2c63c73296a@huawei-partners.com>
 <f6b255c9-5a88-fedd-5d25-dd7d09ddc989@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f6b255c9-5a88-fedd-5d25-dd7d09ddc989@huawei-partners.com>

Happy New Year!

On Tue, Dec 24, 2024 at 07:55:01PM +0300, Mikhail Ivanov wrote:
> The bitmask approach leads to a complete refactoring of socket rule
> storage. This shouldn't be a big issue, since we're gonna need
> multiplexer for insert_rule(), find_rule() with a port range feature
> anyway [1]. But it seems that the best approach of storing rules
> composed of bitmasks is to store them in linked list and perform
> linear scan in landlock_find_rule(). Any other approach is likely to
> be too heavy and complex.
> 
> Do you think such refactoring is reasonable?
> 
> [1] https://github.com/landlock-lsm/linux/issues/16

The way I understood it in your mail from Nov 28th [1], I thought that the
bitmasks would only exist at the UAPI layer so that users could more
conveniently specify multiple "types" at the same time.  In other
words, a rule which is now expressed as

  {
    .allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
    .family = AF_INET,
    .types = 1 << SOCK_STREAM | 1 << SOCK_DGRAM,
    .protocol = 0,
  },

used to be expressed like this (without bitmasks):

  {
    .allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
    .family = AF_INET,
    .type = SOCK_STREAM,
    .protocol = 0,
  },
  {
    .allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
    .family = AF_INET,
    .type = SOCK_DGRAM,
    .protocol = 0,
  },

I do not understand why this convenience feature in the UAPI layer
requires a change to the data structures that Landlock uses
internally?  As far as I can tell, struct landlock_socket_attr is only
used in syscalls.c and converted to other data structures already.  I
would have imagined that we'd "unroll" the specified bitmasks into the
possible combinations in the add_rule_socket() function and then call
landlock_append_socket_rule() multiple times with each of these?


That being said, I am not a big fan of red-black trees for such simple
integer lookups either, and I also think there should be something
better if we make more use of the properties of the input ranges. The
question is though whether you want to couple that to this socket type
patch set, or rather do it in a follow up?  (So far we have been doing
fine with the red black trees, and we are already contemplating the
possibility of changing these internal structures in [2].  We have
also used RB trees for the "port" rules with a similar reasoning,
IIRC.)

Regarding the port range feature, I am also not sure whether the data
structure for that would even be similar?  Looking for a containment
in a set of integer ranges is a different task than looking for an
exact match in a non-contiguous set of integers.

In any case, I feel that for now, an exact look up in the RB tree
would work fine as a generic solution (especially considering that the
set of added rules is probably usually small).  IMHO, finding a more
appropriate data structure might be a can of worms that could further
delay the patch set and which might better be discussed separately.

WDYT?

–Günther

[1] https://lore.kernel.org/all/eafd855d-2681-8dfd-a2be-9c02fc07050d@huawei-partners.com/
[2] https://github.com/landlock-lsm/linux/issues/1
