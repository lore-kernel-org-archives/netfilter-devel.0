Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B067C1DFE1;
	Fri,  9 Aug 2024 14:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723214695; cv=none; b=dapfbfIY9sb+m9ziqAmXtNqC+p7TYB61yzeDVCjTFj0H8s9sYR+4SqkIYoUxnFGNZt4pXTuxWOhPk5eZQfZ+3PhC5VtVDm2GRjtb+MBCUs4LPa71eA8AjmyM7USBX4uyTDnbc1hCmLFvNlEf/k7WSeSu9SMflswQiUCH1UoPm/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723214695; c=relaxed/simple;
	bh=KeCOkdeMj7jfUARfg+0sT1kcD7hB7YWqxUDtJt3Nkw0=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=fr+EFaZiM9/m9Vwdf79e8NoLl6eLOZZkquLvFyJQdI+40p3P+OSOiYwFrgvez4U4gnuSjRdLHnVK0yqZvt7xFP1SHfpeTvoZ81Ax8d5tIZEA54RGrUlMl2qwxGb+7sRqggFebcC4rUKTY+RgKyXNh0nbkWSVQ4Snn329KoNdxTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EGjJA6Uq; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EGjJA6Uq"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-368526b1333so1925208f8f.1;
        Fri, 09 Aug 2024 07:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723214692; x=1723819492; darn=vger.kernel.org;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/dMGgv1RCO9tIGQHpojzXRCbF3RQKlUcFcpP+8JAmc0=;
        b=EGjJA6Uq6pr9on6J0Bf65x1X1Q9PPjufTYO5jW+BYb68pr1LYthL88wKetL4+Nwh12
         V4QfbV18vIEHiXdsRxKvyhP8d+AC8f6Tn8teF99LhG4JUrP7rMVgwN5I5/2f5pt9qPOU
         fJlRiuGF5lLIdDvl5EujQ1O8uz9ZQ3IT3J0lEn+owUX5V/D1BOORxOSWRCjZoGKExmjW
         xaGYw5pvSCxHWwEWmXTGFw5OnVPcKIQH9JqEzf7fvWlVv4gFPgvz5aTqxU85NDcnn0xo
         Q2yB1B08/1F8kIQzWruzKv19A38v+rrDXu5SkZQ455wwji1I+EnV1Po7bn8rS/uxzD6x
         A7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723214692; x=1723819492;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/dMGgv1RCO9tIGQHpojzXRCbF3RQKlUcFcpP+8JAmc0=;
        b=YLrW21bL4AwukRQ7buJGY7NvRO/6ANc9SLGXj7C1m8rBFGNAFmugXm/P8PK4KHqv1T
         QBCFUAUSrWlrdBFw2zE6Ad1PKSP9W9V5PUYc1sbJ0m0eQr3LBmAyVTm5ikjPt5N7cm6u
         5xUKThOJ97HBDRonL7+yCUF+Uvwqr8S7iXGt4ZLPw8MV1ZdALXhZBjpT1PHd5NNRQ2XN
         Wj1ulZPVmt/0sSq+fqdmtnX2kuXs6mDWC0nMJBoRNlQ/bHex3g8FLd42+NYMx9eQX0nX
         R9s7PXOz0bAAF4SKVJTc8AC+5K4GRzUcBhGMswJvrQJR3fvKx3oYqtN/rdbLe7UFlOHf
         2IEw==
X-Forwarded-Encrypted: i=1; AJvYcCXvlJ/GHsIJpA2OydJjn/peywB889BMUq9vhLk0ybO19o4kgE+zTJ+PBIf+zCsvXDmno7+jhidh5KuiTkgEZOHUB++MrMEdRyarxKdrMf9iFuJUMTEBLeSjuYlZlq9ZOWgk2YcElpdQ
X-Gm-Message-State: AOJu0Yw01h0Xj5rpgKrBmUtqnETYM2BvIwKN5qin2L1k3hYbD+LYyOBb
	eBHH1zG3iIAqLjgv2EZP1mKSf9N5smj+49CdcqFe/pMstUf7uS5u
X-Google-Smtp-Source: AGHT+IGLJEeEpwsCiH7unqDJWHo9SYYYVGhxV1yRTrgqx1iRL9g/yNyfLvjK7s1a+VAILfZ9OlehiQ==
X-Received: by 2002:a5d:66d1:0:b0:367:8fee:4434 with SMTP id ffacd0b85a97d-36d68d9de50mr1398005f8f.16.1723214691722;
        Fri, 09 Aug 2024 07:44:51 -0700 (PDT)
Received: from imac ([2a02:8010:60a0:0:f01e:f03a:11db:ad8e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36d27208c81sm5558167f8f.73.2024.08.09.07.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 07:44:51 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Simon Horman <horms@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,  Jozsef Kadlecsik
 <kadlec@netfilter.org>,  "David S. Miller" <davem@davemloft.net>,  Eric
 Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Paolo
 Abeni <pabeni@redhat.com>,  netfilter-devel@vger.kernel.org,
  netdev@vger.kernel.org,  donald.hunter@redhat.com
Subject: Re: [PATCH nf v1] netfilter: nfnetlink: Initialise extack before
 use in ACKs
In-Reply-To: <20240809090238.GF3075665@kernel.org> (Simon Horman's message of
	"Fri, 9 Aug 2024 10:02:38 +0100")
Date: Fri, 09 Aug 2024 12:15:55 +0100
Message-ID: <m25xsaq74k.fsf@gmail.com>
References: <20240806154324.40764-1-donald.hunter@gmail.com>
	<20240809090238.GF3075665@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Simon Horman <horms@kernel.org> writes:

> On Tue, Aug 06, 2024 at 04:43:24PM +0100, Donald Hunter wrote:
>> Add missing extack initialisation when ACKing BATCH_BEGIN and BATCH_END.
>> 
>> Fixes: bf2ac490d28c ("netfilter: nfnetlink: Handle ACK flags for batch messages")
>> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
>
> Hi Donald,
>
> I see two other places that extack is used in nfnetlink_rcv_batch().
> Is it safe to leave them as-is?

There is a memset at the start of the main while loop that zeroes extack
for those two cases.
