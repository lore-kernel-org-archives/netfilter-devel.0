Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838677E;
	Sat, 25 Nov 2023 08:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxYSAuV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FF5C433C8;
	Sat, 25 Nov 2023 08:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700901394;
	bh=72IfUBrnNibzJPMlfkliZerkpcOdn5yzJZBEnENIaIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lxYSAuV+GWL2ajT8+wF6O0uO8Fk3U75nJgrNkfAT84/gMQyx86y0zClZjWDFRX8fW
	 X9CYIhh8oWHf2j5fFYk6RSJqNK0f/KhTrmOmAAQXGDB5nRvR3hYVJATxTPoTU4MZXB
	 VYkfHKQWna/TOHqaN2oTTXzaDab/8fs+iRinyaksN5LZMfb2KBY2vGJ/OiJAX+gOiZ
	 H/KWPmaSlsy2LBf5DRsuWfAYGM99P2Hj0HzeJXwYt0fuiJ/PhsS3EFAm21QBAjnOgt
	 +7xRCYmjqQmbLmYCyfrgAa578UB8QlJqoj04G7q5fuLlAc8oNXuX/v/OwKpwEm6ug6
	 VGCm9YfOhgzcA==
Date: Sat, 25 Nov 2023 08:36:30 +0000
From: Simon Horman <horms@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, lorenzo@kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 1/8] netfilter: flowtable: move nf_flowtable out
 of container structures
Message-ID: <20231125083630.GB84723@kernel.org>
References: <20231121122800.13521-1-fw@strlen.de>
 <20231121122800.13521-2-fw@strlen.de>
 <20231123135213.GE6339@kernel.org>
 <20231123141051.GA13062@breakpoint.cc>
 <20231125082601.GA84723@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231125082601.GA84723@kernel.org>

On Sat, Nov 25, 2023 at 08:26:01AM +0000, Simon Horman wrote:
> On Thu, Nov 23, 2023 at 03:10:51PM +0100, Florian Westphal wrote:
> > Simon Horman <horms@kernel.org> wrote:
> > > > -	err = nf_flow_table_init(&ct_ft->nf_ft);
> > > > +	ct_ft->nf_ft = kzalloc(sizeof(*ct_ft->nf_ft), GFP_KERNEL);
> > > > +	if (!ct_ft->nf_ft)
> > > > +		goto err_alloc;
> > > 
> > > Hi Florian,
> > > 
> > > This branch will cause the function to return err, but err is 0 here.
> > > Perhaps it should be set to a negative error value instead?
> > 
> > Yes, this should fail with -ENOMEM.
> 
> Thanks, I will send a patch.

Ooops, for some reason I thought this had been accepted, but I don't see it
in nf-next.  So I guess I don't need to send a patch for now.
