From: Patrick Schaaf <bof@bof.de>
Subject: Re: Raw Sockets and Netfiter
Date: Tue, 25 Mar 2003 09:12:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030325081216.GJ18652@oknodo.bof.de>
References: <001701c2f29d$20afe1e0$6b01a8c0@COURVOISIER> <20030325072544.GI18652@oknodo.bof.de> <3E800DE4.9070000@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, Ethan Dameron <efd@duke.edu>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3E800DE4.9070000@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> static unsigned int ip_conntrack_local(...)
> 
> Seems like it could be eliminated entirely if you're correct.

I could also be wrong. I have not looked at any concrete code,
just wrote what I thought I understood.

Put a printk() there, run the recompiled kernel, and see if you can
trigger the conditional code. If you can't, remove it, and it's up
to the core team to then explain what's really going on :)

best regards
  Patrick "lazy" Schaaf
