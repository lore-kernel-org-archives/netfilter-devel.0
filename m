Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZOdJBxHJ"
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D06D99
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Dec 2023 16:45:37 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-3b9b90f8708so3288088b6e.2
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Dec 2023 16:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702341936; x=1702946736; darn=vger.kernel.org;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:to:date:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4PG1o95oY4qZKgIjcLoVxEAkFVzYSmAA4GqlPZtundY=;
        b=ZOdJBxHJtWL1td+mN4kXI/ohSCrOKYMNUH+KFlBobVNHN73eVA/sndCQhoaHO/xLvR
         lQJuTE4xgNmOacjKcFb1bkGu8D2za665On2hpFPifYbmoqQ7bRxHfHHdHr7WI5e/hedZ
         kySRhAWTNGI8Ggv1WHuNgPDcKzgAnFOVwqH/39IX1eLcYX8AJ8/vf3GM7XhRg1GpZDUd
         MXUNIz3i27EcZnjZjxnkG7yZmyeB7sznzVyqJdbtSpqoNo8+0Gu0OjQ50evyPbCoUBwD
         O49HgctT/LLjjr+SfB9938tXCtat9luDii21WkIYfNCEAeZMyrVFbOhm+8GyCjMMsIGv
         S07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702341936; x=1702946736;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:to:date:from:sender:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4PG1o95oY4qZKgIjcLoVxEAkFVzYSmAA4GqlPZtundY=;
        b=ms62+baBb8gih+f2x599Z8KY+TsegQM5nJhl0SPHIPh+tjUVOWRHCjb3jC/tWh9MRk
         vD3IX6o4nfeffCSuJBl8uzjR7w+lGFo1/cXQnmk5uNHbxcpzLMhHf1NMBTJ5FYZdgDUS
         +6S3Q1tatVBhnojemonwg0lHFTuByIzi/b0Eb0gSqu5luBJ8E4X9fui78SA71ehe5EPH
         NH+/M9RpNVksMwFmuTJvFt81l3gEllsBUvsI6xzrsm+ZvjWI5baDtfIq9UuIJi7vqe4s
         iqg4mZ8yDEGZGm8hT3J9KeCFFgI6HTSaq6YJv8io37SkknDr0OI9CUZCzZ0LLb71R1+G
         LFJw==
X-Gm-Message-State: AOJu0YyrEaLM8WMtdneIWxJCJKO1HmPgo4TGJOcpp6r4/zbnoIiyc47K
	0rsm+DoTmnxWiElQqumhdru368MrR2I=
X-Google-Smtp-Source: AGHT+IHuEBYatmY6Rg3AN40S5HY+ynchx5cKBecvbT/foi6lfVv6Nkh39pSe3Qv7qklnSEAujiJneA==
X-Received: by 2002:a05:6808:209e:b0:3b9:d749:7600 with SMTP id s30-20020a056808209e00b003b9d7497600mr5378359oiw.58.1702341936299;
        Mon, 11 Dec 2023 16:45:36 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id fa11-20020a056a002d0b00b006cb95c0fff4sm6933828pfb.71.2023.12.11.16.45.35
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 16:45:36 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Tue, 12 Dec 2023 11:45:33 +1100
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Should we keep the advice to increase queue max length?
Message-ID: <ZXetLVAKMug1YvL3@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Everyone,

Under the title "Performance", libnetfilter_queue main page advises

> increase queue max length with nfq_set_queue_maxlen() to resist to packets burst

but from experimenting it seems to me this does no good at all.

/proc/net/netfilter/nfnetlink_queue has a line for every active queue. The 3rd
field is the number of queued packets. The max length is not in these lines but
kernel source suggests it is 1024 by default. Anyway, I updated nfq6 to be able
to set the max (using mnl functions).

And I found the maximum number of queued packets is: 238. Further packets are
dropped.

If I lower the max below 238, limiting occurs at the new max.

So I propose to drop the advice to increase the queue max length when I revise
the libnetfilter_queue main page as part of the project to stop using
libnfnetlink.

Anyone have any comments?

Cheers ... Duncan.
