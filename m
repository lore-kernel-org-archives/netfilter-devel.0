Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3721038DC3;
	Tue, 19 Mar 2024 18:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710874016; cv=none; b=PSML0mJrCO7D+jt4RgT7HAKLLsj4x9Nw2uXCkvDgvso1zhVtpq9ZCqKGOz3PVuSc0WtAOWcGDrc89HTlq2wxDwrUsH4zeuv3GgzH2llvvUG7K+oepL6ZTZngmQSqbqtXdMWULuqwDUXtUOlGDXJ/1eTrolVld6VUZKnQGIHFNFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710874016; c=relaxed/simple;
	bh=kCLTyFRMVvPPK2LGlEL+DICGBEMoPRX0K0T4yslSmFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCe2hxvk7+GdgiYfhvGD6uSe/G8h8YWisdLQQro2aOei4CuQNcrKiGeZMbMuGc/+gjJaJAIm2Pn1oYtJvnKGEJ3mPAvWCVf7XxP89Lw5YEj72lurUZEdP4jYP0Dzxf+UjHj3hm/XdbEqmYhKexMpSrczFIkuxoAl4EUnDPuJMD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uzgQA/Oh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uzgQA/Oh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F19C433F1;
	Tue, 19 Mar 2024 18:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710874015;
	bh=kCLTyFRMVvPPK2LGlEL+DICGBEMoPRX0K0T4yslSmFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uzgQA/Ohe8DfGULywXncgYLnTQHHI8lJqBwvNml5ByyOvPVpql3nIukCH9KegK5IP
	 rKN4Ar60nHD1vVG6QVnjljHv/+ZxcUYZLkXmnACl65MnOU1DVkpCSrSjrAJrJSzy3v
	 S6LZxPPGCWJxgWphatS3XcjSxbX6bKT6QOCJ98HH0WYot+IPNwTRMYFaHvlHtZcTC6
	 mVUPVmS/gEE2RxihTEjqMTg4AnkNK4CDcpSExd6Q5JaBW2K4BseRivZc/NZzxto8pd
	 OLw/1pAMcCxdu2gyaxCI5/WFAPWaiefS+fCCpcVndG6zcpt3Ma3zjujtlkNC9P5reV
	 AYbTSlQ9OL1hQ==
Date: Tue, 19 Mar 2024 18:46:51 +0000
From: Simon Horman <horms@kernel.org>
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org,
	fw@strlen.de, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
Message-ID: <20240319184651.GN185808@kernel.org>
References: <20240311070550.7438-1-kerneljasonxing@gmail.com>
 <20240318201608.GC185808@kernel.org>
 <CAL+tcoCDs+0OJ3VE59KSyvvyzOxqf0SW-hojDeccwdB=PazwqA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL+tcoCDs+0OJ3VE59KSyvvyzOxqf0SW-hojDeccwdB=PazwqA@mail.gmail.com>

On Tue, Mar 19, 2024 at 10:52:44AM +0800, Jason Xing wrote:
> Hello Simon,
> 
> On Tue, Mar 19, 2024 at 4:16 AM Simon Horman <horms@kernel.org> wrote:
> >
> > On Mon, Mar 11, 2024 at 03:05:50PM +0800, Jason Xing wrote:
> > > From: Jason Xing <kernelxing@tencent.com>
> > >
> > > Supposing we set DNAT policy converting a_port to b_port on the
> > > server at the beginning, the socket is set up by using 4-tuple:
> > >
> > > client_ip:client_port <--> server_ip:b_port
> > >
> > > Then, some strange skbs from client or gateway, say, out-of-window
> > > skbs are eventually sent to the server_ip:a_port (not b_port)
> > > in TCP layer due to netfilter clearing skb->_nfct value in
> > > nf_conntrack_in() function. Why? Because the tcp_in_window()
> > > considers the incoming skb as an invalid skb by returning
> > > NFCT_TCP_INVALID.
> > >
> > > At last, the TCP layer process the out-of-window
> > > skb (client_ip,client_port,server_ip,a_port) and try to look up
> > > such an socket in tcp_v4_rcv(), as we can see, it will fail for sure
> > > because the port is a_port not our expected b_port and then send
> > > back an RST to the client.
> > >
> > > The detailed call graphs go like this:
> > > 1)
> > > nf_conntrack_in()
> > >   -> nf_conntrack_handle_packet()
> > >     -> nf_conntrack_tcp_packet()
> > >       -> tcp_in_window() // tests if the skb is out-of-window
> > >       -> return -NF_ACCEPT;
> > >   -> skb->_nfct = 0; // if the above line returns a negative value
> > > 2)
> > > tcp_v4_rcv()
> > >   -> __inet_lookup_skb() // fails, then jump to no_tcp_socket
> > >   -> tcp_v4_send_reset()
> > >
> > > The moment the client receives the RST, it will drop. So the RST
> > > skb doesn't hurt the client (maybe hurt some gateway which cancels
> > > the session when filtering the RST without validating
> > > the sequence because of performance reason). Well, it doesn't
> > > matter. However, we can see many strange RST in flight.
> > >
> > > The key reason why I wrote this patch is that I don't think
> > > the behaviour is expected because the RFC 793 defines this
> > > case:
> > >
> > > "If the connection is in a synchronized state (ESTABLISHED,
> > >  FIN-WAIT-1, FIN-WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT),
> > >  any unacceptable segment (out of window sequence number or
> > >  unacceptible acknowledgment number) must elicit only an empty
> >
> > Not for those following along, it appears that RFC 793 does misspell
> > unacceptable as above. Perhaps spelling was different in 1981 :)
> 
> Thanks for the check. Yes, it did misspell that word. Should I correct
> that word in my quotation?

No, I think you should keep the quote the same as the original text.

> > >  acknowledgment segment containing the current send-sequence number
> > >  and an acknowledgment..."
> > >
> > > I think, even we have set DNAT policy, it would be better if the
> > > whole process/behaviour adheres to the original TCP behaviour as
> > > default.
> > >
> > > Suggested-by: Florian Westphal <fw@strlen.de>
> > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> >
> > ...
> 
