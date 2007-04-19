From: "Samuel Jean" <jix@bugmachine.ca>
Subject: Re: netfilter modul ipt_recent hickup with suspend to ram
Date: Thu, 19 Apr 2007 19:24:20 -0000
Message-ID: <twig.1177010660.84387@bugmachine.ca>
References: <4624E196.7060004@trash.net>
Reply-To: jix@bugmachine.ca
Cc: netfilter-devel@lists.netfilter.org
To: "Toralf Förster" <toralf.foerster@gmx.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200704191920.05567.toralf.foerster@gmx.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Apr 19, 2007, Toralf Förster <toralf.foerster@gmx.de> said:

> Might be I misunderstand something but shouldn't the recent module
> delete entries after 60 seconds or so ?

IIRC. There is no garbage collector in this module. It justs purge entries
and allow other packets to override the expired entries.

If what I assume is right, you won't see any change to that file if the
rules using this module are not hit.
