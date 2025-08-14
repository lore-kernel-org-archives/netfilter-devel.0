Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C21238C24;
	Thu, 14 Aug 2025 15:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755186346; cv=none; b=eP6OaH79tHtOVm2izzZalaNpdYis5MVjQKuMSpVR1PG7Z7sQAHsFOKNry5dGIdK5HLKQhT5mr4pvRLOrrS5A8EzvxXj8Id0gsngQmN7xeT6mxZROz/ew22s/1KZ7cOrcz22E4oEM6dilTG80ODePk8fBz6AbR8UG8VTCo3dt1AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755186346; c=relaxed/simple;
	bh=8PhsoonV74hS11HznyhtwwEr2mmvi6egb8cha1qlM7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cq5rCdRVj8YLdlLC3Y0reWYrUDl0N2j6yTktWQ9AECRugozhxPfHYWkQ9v9JA6NqEDh4qJd+E8NElf4a5BiFuXfzvSpZZrjg/CT4PwgmnLLBO1Bk6SLYWWHQd6tEl3h1zSXqku3PkgOggmdsuXR57PaVvmLMRyxYJIbkMA3eKwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c1dV5XCn; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c1dV5XCn"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-24457f3edd4so8268185ad.0;
        Thu, 14 Aug 2025 08:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755186344; x=1755791144; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2zPOjzgJ6ei3R7tSEzyHsuGUiKphrQk/wfZ7YvshtY8=;
        b=c1dV5XCnDh30/E8wEBRo8f9hEiH50egncSDSnxO8rwaesO1hn2CLNTYIdKl9Uz14jC
         4Hk0uhEqO683jfjfp8yie0+9hxvD/EDkadUn3lSflEk1zD4Rh6Pu/C4W6w9Bq2LYFjE6
         2NUkQtVlWISsaBT+sRxnj2P8hpJk640NbJiLVgKEqXsJxP6qhjba0AnKFcnomszoXhp3
         gp3xrn7EzOutHu1xVfBitdQ//wFNIoiFcizGliznNKrckcZ1LM0+eN9dkOLpt2nlfFdU
         bvsDJ52Bk/z+7KcAO95nvlPamLc0B9bcaX35m67FG8M6OvzsZBbZptOfFUM5Wceav8Gn
         v73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755186344; x=1755791144;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2zPOjzgJ6ei3R7tSEzyHsuGUiKphrQk/wfZ7YvshtY8=;
        b=Syo1vL64T/biIFn5AAk4F3o56Hs7N0i09DqWhSim8pKc+qr9yaFsSj2ky1neXnrR17
         o9iBYn22A7i2YJf4rCzPJkUMj31TRz8jhu4XGfFhEvunEpo3rBgKZFo+I7hH4lTZNOhA
         YcO7wjteosYP/W6tX4Vic4KcmtXcdli+MaoCS+/JmJ30L1D025/rUMSn4uGEUPeH7dgc
         vK4a0Xnatfl2yOuK1S+1nvHF2bVI2ehqk2JeSYujWOwZhY39TipNOmoI3lJlCofbKA6k
         Fwh5XLfavKTzS7+WrNIK/QLFOMod9En/ToOerg5H+KSRRYvRL91W61wpR9WW07cDynkA
         Es3w==
X-Forwarded-Encrypted: i=1; AJvYcCVSoSuMJnvm0ioy/U4uray8Dh0K0n9yMuFgsD6th3rfyqex5TJrQfkfsaCuKAE4oYi9HLGYTaLG7HwBJ/Q=@vger.kernel.org, AJvYcCXZjSc8P8SjcfNr64vR9sFad/6SlH55q/SsL8eGl1q+l4CXzCFtRM3YujclO/fWaqC/VpRA/OCSgJ8Xg+8iqcAN@vger.kernel.org, AJvYcCXn9UlTdh7wWA8AJ5LaJjxL63EqIKfHFstX2i3Sbz70jjmCP1pvtNXm2HmK3Q+wqov6M+iH/F6t@vger.kernel.org
X-Gm-Message-State: AOJu0YyT5BgJDzkFH5uW59w8GmekjO04UZSW4SDXFu+qFf2qofxxHCrs
	n8M/Or7D+BkFIe1QyB0aREEJi7vw9NMdDxaxMAANcTwE4hJm/cZdaiY=
X-Gm-Gg: ASbGncvMOYHlqIWlAybIqJD95S9HPhxLqmnprNLhr2u1mDfp0bkjntdqdVlj/mY7Ecj
	sik3Xarhdduk9Kc1Qnt7dzclzysUQA71679GBoM5x5NhnQOLZnnGDazDF8frVIKOWQWiftdGxso
	9FdabIlA02ZnAldIU9ZvjiZ/XZ+We4DzVpdLWQo7iiovkQUy/4kk4Fxn6JkXo9MB0nzeT5ZwUad
	PS7tVqXHILlw9PcGt9XKje6qGl117T36lJxeag0LDaLKiu7YH7R+YZTLHzr+8GRPgfibvz5looL
	jUmHvIhOR82h08EFb6ILfKVjyFD9+hrYOyH4lLJFI0bsJN009IaocFE+FZvX7uMRFI5gxJ/x7sc
	SyodRKs3miAE4ydItx2URwcRbi94wAlZtaH4o8Y2I2KIGGl/AYFIYkZ6GC6go1tWujTVXpw==
X-Google-Smtp-Source: AGHT+IGlxL2vO5rbswwUa03fBzurJOLXDC3ZMd0abz8+oqyFcg/bSZ3VQpRRuzxa9ZBIROVNKsj8mQ==
X-Received: by 2002:a17:902:f602:b0:242:b315:ddaf with SMTP id d9443c01a7336-244589fe5e0mr49988975ad.7.1755186344057;
        Thu, 14 Aug 2025 08:45:44 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-241d1f1ebc1sm353014885ad.67.2025.08.14.08.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 08:45:43 -0700 (PDT)
Date: Thu, 14 Aug 2025 08:45:43 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>, netdev@vger.kernel.org,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	ayush.sawal@chelsio.com, andrew+netdev@lunn.ch,
	gregkh@linuxfoundation.org, horms@kernel.org, dsahern@kernel.org,
	pablo@netfilter.org, kadlec@netfilter.org,
	steffen.klassert@secunet.com, mhal@rbox.co,
	abhishektamboli9@gmail.com, linux-kernel@vger.kernel.org,
	linux-staging@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH net-next 1/7] net: Add skb_dst_reset and skb_dst_restore
Message-ID: <aJ4Ep13RwUSdJZfb@mini-arch>
References: <20250812155245.507012-1-sdf@fomichev.me>
 <20250812155245.507012-2-sdf@fomichev.me>
 <20250813175740.4c24e747@kernel.org>
 <20250813180313.284432a8@kicinski-fedora-PF5CM1Y0>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250813180313.284432a8@kicinski-fedora-PF5CM1Y0>

On 08/13, Jakub Kicinski wrote:
> On Wed, 13 Aug 2025 17:57:40 -0700 Jakub Kicinski wrote:
> > On Tue, 12 Aug 2025 08:52:39 -0700 Stanislav Fomichev wrote:
> > > +/**
> > > + * skb_dst_reset() - return current dst_entry value and clear it
> > > + * @skb: buffer
> > > + *
> > > + * Resets skb dst_entry without adjusting its reference count. Useful in
> > > + * cases where dst_entry needs to be temporarily reset and restored.
> > > + * Note that the returned value cannot be used directly because it
> > > + * might contain SKB_DST_NOREF bit.
> > > + *
> > > + * When in doubt, prefer skb_dst_drop() over skb_dst_reset() to correctly
> > > + * handle dst_entry reference counting.  
> > 
> > thoughts on prefixing these two new helpers with __ to hint that
> > they are low level and best avoided?
> 
> Looking at the uses -- maybe skb_dstref_steal() or skb_steal_dstref()
> would be a better name? We have skb_steal_sock() (et.al.) already,
> same semantics.

Sure, will rename and address the rest of your feedback. Thanks for
the review!
