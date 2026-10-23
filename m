Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774128;
	b=XgUC75XBJNk4PQRXjctScfJJVDSNGxf/F1zzuCGIQkaS18FKz5nL8t5wFB6jIUcpxIHB
	 9WbNZGOsk0VOZhYq/UuGuCA8NE+Gmv3RbmF/pd/jlgzK+WM1Dbtop7U0bnhuzdDKDR3ec
	 85JW5vfrzYhwJE6y7Wi/F3wzDrkgGFhA/1/7uTSd3qjy6sd/F87dwd21lWrir5phTAVTF
	 KBVW7P8oGLtPsBifdpU1r+xCq1Fwx2MDfj95U32xgFdayxqspppnsmnEqGC5lzrWz02AX
	 qU39x4+sbFOdlYoQj/R0/51gGe2C+Yt2AINF4XcRknP1MnF5YMd2bHlt1gf6OAgBImw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774128;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=l4yjbuyU9tYNCrKIyPpIJSh4fdlXELraeddszflbbg8=;
	b=d+dfFcgO0CFjkuaP/C8dVkSTp3yCp39JWoCLb+F8iEnnKwL1d2sVVENSO3k0IZMAGpeU
	 WIv+MaHknf6qTtTiNQKUKxKW/hT9jfX5ueu9+O938abZFtu6yvaFZSJl0s8FvD97Fz9Qq
	 F5gqaSZ03hAlzYQcKDOBn/D5XaJM95o9gdcBxB31kWXZlxEuFj02n/DDw9Wto93FfFvrS
	 MtHThqg/mtLYi8ejVs8GrJv8EDYoTJ8CH8/PXNoMwHYw0RmTXxYtH7Zu7y3K5e1bZdqFM
	 pZz2sQM4g/Q+jdDEQqHLw8Weh9E5wx3wSpwaLbOGUXaE/9IQ9pmhYx1vB3dutz6BVOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gU82Iq7X;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=BPTSbtP3;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDB1606A32C
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 16:48:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEDB1606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gU82Iq7X;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=BPTSbtP3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792774126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l4yjbuyU9tYNCrKIyPpIJSh4fdlXELraeddszflbbg8=;
	b=gU82Iq7Xsy1bpWiIWtNPit9g5SQIShMVBOyJwx+nwb+BjP3l+EB4PoCljAmCX4l/1T7dUD
	+6tTkweWJ8evAupHVvRN6kSm2boS84zitk73UcCxFYaXggpoiJzkpIUtJC6FUrJtrqd0rN
	IVMs4Kh2OrhM3PI9LV69RzWvXdes1A0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-E0EWSRCmObGJApVlMuj-eQ-1; Fri, 23 Oct 2026 12:48:45 -0400
X-MC-Unique: E0EWSRCmObGJApVlMuj-eQ-1
X-Mimecast-MFC-AGG-ID: E0EWSRCmObGJApVlMuj-eQ_1792774124
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48e0461e040so822819f8f.0
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 09:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792774124; x=1793378924; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l4yjbuyU9tYNCrKIyPpIJSh4fdlXELraeddszflbbg8=;
        b=BPTSbtP38Ln26csJh7P5NEPySUmwcR/oqoTqdMjgeJkjJBOfGB8oGdKqWEV/5J4sYF
         tQZFeOyjtUZM17SHhTrADGwRtiCxcCFahBStsgRWDzu59gAZSm6ZlcRm5Yu2Acq45xl7
         bq3PxX/+PW7aigDWF5Ew/Y41SiQ5eh1FAZPOyWxn8w1Gu/VWA65StYbjUlx7LXNAMiL2
         dVc4MBmkMHysXZKAuM5sLu+e+Li2DHNMg1GPrnko910TBqQlXSEfXlp4m645oFcA27/y
         aYPiOuNEO1A0vaRAaMqukmjONYIY6oKy/O7nsOAiIQ1z9Yyk5mMfbT2W7m2P73WjIsBv
         7R3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792774124; x=1793378924;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l4yjbuyU9tYNCrKIyPpIJSh4fdlXELraeddszflbbg8=;
        b=jt0tJJf5kpIjeEG/iFw2M8ljVZrIUaLWxOAz8Dt4QR1VG8wATJnhibQhgUch1+Vr5e
         Z0SKW3BNkOKFgdT5c8RnsssHFTkjyXTVAZ/cvCT1WHwyiNOj0aYWGzD9dBrTA+PLy2gx
         CNdu9PoRmRkWLz6EdJyza7E+Xe+w3ft0a98CvrADppL0LpxBv6YzLYCV8mOJNW8U/9bM
         voaO8tRtU2WqoNBUdcnDz3rwx3uXWqoktIj4yYBdmKgYAnJjWN0b94umWmHnfKsXxO7+
         424Di1jUihYoLJL5tg/7aTWdmX1jL+48eEvdCakFLBHmNvkZvPeozpX/2FEjkKmxN/zk
         I8ww==
X-Forwarded-Encrypted: i=1; AKwUvBw4cZpZyhWHdFJVAvxM2xgbS+y2uVoekU+LmS8TpG4jKf6f9V9M6/mxPFwlZYSJZ8kj1DQtSeFv9K0xVxAp1cg=@vger.kernel.org
X-Gm-Message-State: AFq9FYLpaY6VbUtUaLP4jQA1x8NwHOoCVbLKC2s/mZ8G17UAevvECtzM
	9PdnwJvXdtlGHsYrg747hg7pqJrol4W0nuHK/I/fbFVkrUWA9SF0xEdErE/wIvPt7frxQXIza1j
	3jdfYmarlGQvy6QOCtNm7dZcgEcey5YB3oNOv1ACCkndPA2O2b9hrcYkysDuWdecOrW71Vg==
X-Gm-Gg: AYBFou1TfhDUkxLixKnhtqtVrsfPwEAryJvBi66rbbclrBTdnlChlz6zYBfRjn3RhdB
	JxJBW+UiS96/vuT1U36iM07aLar1PSF8NSRROuUUx0U4VLGhJbrxHbNY/u8UR/FSwiBmR6BQyN1
	iihSXAFe6+FM/N+p/RqMFWex43AHH9mdm3NZLGkakcBiJFzaBHAceXi0oY+rsCPaZamR0PwbstI
	cIMTb+M6bmcTJOVmAbyw8p8L/D97eLBI1OA2giwN5B3b6V2LzaUtwJEus3tMr7J/WHB3pqJjh7V
	agRYSRGIB/c8FVYjcGLIgtDP5OXK9Nc4VXp1skpOdHkv0nu1q7ziQ+epD+X33LUr4090E1k=
X-Received: by 2002:a05:6000:4026:b0:48d:eb6b:9d0f with SMTP id ffacd0b85a97d-48e385ac430mr4702389f8f.11.1792774124031;
        Fri, 23 Oct 2026 09:48:44 -0700 (PDT)
X-Received: by 2002:a05:6000:4026:b0:48d:eb6b:9d0f with SMTP id ffacd0b85a97d-48e385ac430mr4702351f8f.11.1792774123549;
        Fri, 23 Oct 2026 09:48:43 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73f6:2400:30a8:9e33:7d82:c035])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3d37c4b7sm1157431f8f.2.2026.10.23.09.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 09:48:42 -0700 (PDT)
Date: Fri, 23 Oct 2026 12:48:39 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Chris Arges <carges@cloudflare.com>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	Phil Sutter <phil@nwl.cc>, Jason Wang <jasowangio@gmail.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, virtualization@lists.linux.dev,
	Max Krasnyansky <maxk@qualcomm.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>, Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev
Subject: Re: [PATCH net v6 6/6] net: add ip4_parse()
Message-ID: <20261023124740-mutt-send-email-mst@kernel.org>
References: <cover.v6.git.mst@redhat.com>
 <970e2341834eadcf265fa7dd61a05ee305fdc1e4.1792687500.git.mst@redhat.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <970e2341834eadcf265fa7dd61a05ee305fdc1e4.1792687500.git.mst@redhat.com>


This one was sent by mistake. Pls ignore.

