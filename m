From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] Multi-namespace support (Request for comments)
Date: Mon, 15 Oct 2012 00:05:28 +0200
Message-ID: <20121014220528.GA1432@1984>
References: <1350184376-7957-1-git-send-email-aatteka@nicira.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ansis Atteka <aatteka@nicira.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40185 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab2JNWFp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Oct 2012 18:05:45 -0400
Content-Disposition: inline
In-Reply-To: <1350184376-7957-1-git-send-email-aatteka@nicira.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 13, 2012 at 08:12:56PM -0700, Ansis Atteka wrote:
> This patch should not be considered complete! It was sent out with intention
> to propose feature and receive further comments.
> 
> It enables single conntrackd process to synchronize state among multiple
> namespaces. To test this patch apply it on the top of this one:
> 
> http://markmail.org/thread/npxklk4p6g4y3rup
> 
> And use following conntrackd.conf on both hosts:
> 
> Sync {
>         Mode NOTRACK {
>                 DisableInternalCache On
>                 DisableExternalCache On
>         }
>         UDP {
>                 IPv4_Destination_Address <host[1|2]>
>                 Interface breth0
>                 SndSocketBuffer 1249280
>                 Checksum on
>                 Port 3781
>         }
> }
> General {
>         Nice -20
>         LogFile on
>         LockFile /var/lock/conntrack.lock
>         UNIX {
>                 Path /var/run/conntrackd.ctl
>                 Backlog 20
>         }
>         NetlinkBufferSize 2097152
>         NetlinkBufferSizeMaxGrowth 8388608
> }
> 
> The configuration above is used as template when instantiating
> the actual configuration for every namespace. Use following
> commands to do that:
> 
> host1: conntrackd -A namespace1 /var/run/netns/namespace1
> host1: conntrackd -A namespace2 /var/run/netns/namespace2
> host2: conntrackd -A namespace1 /var/run/netns/namespace1
> host2: conntrackd -A namespace2 /var/run/netns/namespace2
> 
> The first argument is the namespace identifier and second
> is the path to the actual namespace mount point.
> 
> This patch doesn't work correctly yet with:
> 1. caches
> 2. FTFW or ALARM modes
> 3. filters (it seems a little bit tricky to unglobalize it)
> 4. expectations
> 5. and it even breaks the current conntrackd usage (it does
> not create state object for the current namespace)
> 
> Currently I am protoyping another patch that will allow
> to synchronize different namespace subsets between more
> than two hosts (i.e. each ns_state will reference the
> right multichannel structure and use it).

This is a large changeset but seems reasonable if you put care on it,
and that will require several rounds of comments.

I have dedicated a lot of time to stabilize this software. If you want
me to take this feature, you'll have to put *a lot* of care on the
patches, really.

BTW, better split this in some patch stack. First small patches for
little changes you require to prepare the ground for your feature.
Then, the last patch should be your new feature.

Check tools like stgit to work with stack of patches in case you are
not familiar with.
