Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959023B5847;
	Wed,  9 Sep 2026 22:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788993329; cv=none; b=PLqKV+JRnudOuGkbz2KFGiD1NyCW3bU0b7+9ztGAnFQXVjVNBhCKIncSK1UOC6yLp+DfK+4OeC9W+yQFlV0ejNGr0+h00+e2wbR8PT5bDUps+rZ7nUSeKRuGOyXXxL9ZzmTFgir42SuO3rA/yxfq7F3fSFSszCwP/Zbj1syPX88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788993329; c=relaxed/simple;
	bh=yFtgdn+u2QJ1Xx1uvXp5xwY1qfcW+2HzWXNluZkkjKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LuTT6/VTO7zLC2yDmSP1040DwwBJQ5pdPpFxV+PA0MryF6cUAfzmotpbQZpK5ZQoLxEVIuZFNNOyQMMl5vnqpyMcHJmEW7sJu82eEYTUfIUnGf1Unk0ZILYeJkxI0pG2uDoy0W8/Ggv7E0qi47INJTGpOsWioxeU8A/DX1ErQX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jIdw1yvn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jIdw1yvn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788993318;
	bh=7+B9uj40SlmoB4IWZIg/g7aPg7FzqFLWgGp1K92U7LY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jIdw1yvneOkKzVRTn4phHmsJ+T2pDAWqVJAx2uNZdmU1Z+q4CwuY+GKhNDTVZY6zd
	 /yJIQ0usYCdzQuBFFwwm64Ce5uHKniJo7zRbIiEjdLgKybiLfLqWmsTqypZBYAMQe+
	 7SYXoQ7f8q2roD3dPneQh1zbAr2tK2xLPTqOF2cql03X9sOEuJZJ1J0q3k8woZJipj
	 SOhXj4jGZaLpPV73Mt5vKUlGbDisMpn0VoMazcDC2mbgr9o5Fa2ZXl94AUXNvN6bSx
	 40P+E5jPZJh4GSXD03NREgMB6Jc94et4G+bFlz5KiebVuJUWk8PDmJqd5kI94CFuJV
	 Z6leevJ2br2pw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C952F607BE;
	Thu, 10 Sep 2026 00:35:18 +0200 (CEST)
Date: Thu, 10 Sep 2026 00:35:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Alexandre Ferrieux <alexandre.ferrieux@gmail.com>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_dup_netdev: scrub duplicates to
 preserve the direct path
Message-ID: <aqHfI6oUshVdFkR-@chamomile>
References: <20260804201150.16364-1-alexandre.ferrieux@orange.com>
 <anLzQeYulW2CQItC@chamomile>
 <7b7fbe75-1531-49f9-8134-033c34fa13cb@orange.com>
 <64228e38-b619-4836-aa41-1594567db082@orange.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <64228e38-b619-4836-aa41-1594567db082@orange.com>

Hi,

On Wed, Aug 12, 2026 at 01:19:07AM +0200, Alexandre Ferrieux wrote:
> Hi,
> 
> >> On Tue, Aug 04, 2026 at 10:11:50PM +0200, Alexandre Ferrieux wrote:
> >>>
> >>> In other words, the "dup" path has the potential to wreak havoc
> >>> in the direct path as a consequence of secondary link failures. This
> >>> is very bad behavior for a monitoring tool, which is the most
> >>> obvious application of 'dup'.
> >>
> >> Can you describe your use-case a bit and how it breaks?
> > Sure:
> > 
> >  - assume hosts A.eth0 and B.eth0 have active production traffic (say TCP)
> >  - assume we have a monitoring tool on A that dups eth0's egress to some other
> > interface $MON
> > 
> >     nft add chain netdev ta ch '{type filter hook egress device "eth0" priority
> > filter ; policy accept ; }'
> >     nft add rule netdev ta ch dup to $MON
> > 
> >  - assume something goes wrong on $MON generating link failures. In my case it
> > was a GRETAP with L3 destination suddenly unreachable.
> > 
> >  - The next A->B packet goes through normally, but its duplicate hits
> > ipv4_link_failure(), hence the dst (which is B) is expired.
> > 
> >  - As a result, (say) TCP disruptions occur. The thermometer killed the patient :)
> > 
> > Note: as a straightforward repro, you can simply witness "noise" in simple ping
> > sessions, with ghost unreach reports muxed with normal measurement:
> > 
> >     ip link add gre1 type gretap remote 192.168.1.99 ;# on the LAN, nonexistent
> > IP => will generate link failures
> >     ip link set dev gre1 up
> >     nft add table netdev ta
> >     nft add chain netdev ta ch '{type filter hook egress device "eth0" priority
> > filter ; policy accept ; }'
> >     nft add rule netdev ta ch counter dup to gre1
> >     ping -n 8.8.8.8
> >  =>
> >     PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
> >     64 bytes from 8.8.8.8: icmp_seq=1 ttl=115 time=19.9 ms
> >     64 bytes from 8.8.8.8: icmp_seq=2 ttl=115 time=12.8 ms
> >     64 bytes from 8.8.8.8: icmp_seq=3 ttl=115 time=36.0 ms
> >     64 bytes from 8.8.8.8: icmp_seq=4 ttl=115 time=30.3 ms
> >     From 192.168.1.13 icmp_seq=5 Destination Host Unreachable
> >     64 bytes from 8.8.8.8: icmp_seq=5 ttl=115 time=31.0 ms
> >     From 192.168.1.13 icmp_seq=6 Destination Host Unreachable
> >     64 bytes from 8.8.8.8: icmp_seq=6 ttl=115 time=38.0 ms
> >     From 192.168.1.13 icmp_seq=7 Destination Host Unreachable
> >     64 bytes from 8.8.8.8: icmp_seq=7 ttl=115 time=36.8 ms
> >     From 192.168.1.13 icmp_seq=8 Destination Host Unreachable
> >     64 bytes from 8.8.8.8: icmp_seq=8 ttl=115 time=23.5 ms
> >     ^C
> > 
> > 
> >>
> >>> This patch fixes all similar scenarii by calling skb_scrub_pkt()
> >>> on the clone, severing its link to precious direct-path state.
> >>
> >> This patch is targetted at the net tree, but nf.git is preferred.
> > Okay, will retarget :)
> > 
> >> As for the conntrack and dst, you have to explain what it breaks on
> >> your end.
> > Dst as shown above. Conntrack is more speculation, but my take is that in any
> > case the dup path should *never* have any kind of retroaction on the observed
> > path, so any "complex state" attached to the direct path should be absolutely
> > isolated from "whatever happens on the dup path". Am I mistaken ?
>
> What do you think ? Is the description of the problem satisfactory ? Is the
> proposed solution acceptable ?

I think conntrack should be set to untracked for the dup.

And dst should be resetted if skb_valid_dst() returns true, so
DST_METADATA can still be processed for duplicated packets.
