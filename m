From: Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCHv2] netfilter: nf_conntrack snmp helper
Date: Tue, 18 Jan 2011 18:21:52 +0100
Message-ID: <20110118172152.GE1941@jolsa.brq.redhat.com>
References: <20110114201805.GC4546@jolsa.brq.redhat.com>
 <4D31C804.5090304@trash.net>
 <20110117094547.GA1918@jolsa.brq.redhat.com>
 <4D35997E.6060502@trash.net>
 <20110118163758.GC1941@jolsa.brq.redhat.com>
 <4D35CA59.8080602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab1ARRV5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:21:57 -0500
Content-Disposition: inline
In-Reply-To: <4D35CA59.8080602@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 18, 2011 at 06:14:01PM +0100, Patrick McHardy wrote:
> On 18.01.2011 17:37, Jiri Olsa wrote:
> > Adding support for SNMP broadcast connection tracking. The SNMP
> > broadcast requests are now paired with the SNMP responses.
> > Thus allowing using SNMP broadcasts with firewall enabled.
> > 
> > Please refer to the following conversation:
> > http://marc.info/?l=netfilter-devel&m=125992205006600&w=2
> > 
> > Patrick McHardy wrote:
> >> The best solution would be to add generic broadcast tracking, the
> >> use of expectations for this is a bit of abuse.
> >> The second best choice I guess would be to move the help() function
> >> to a shared module and generalize it so it can be used for both.
> > 
> > This patch implements the "second best choice".
> > 
> > Since the netbios-ns conntrack module uses the same helper
> > functionality as the snmp, only one helper function is added
> > for both snmp and netbios-ns modules into the new object -
> > nf_conntrack_broadcast.
> > 
> > v2 changes:
> >   - exporting nf_conntrack_broadcast_help via EXPORT_SYMBOL_GPL
> >   - nf_conntrack_broadcast object now built based on new config symbol
> >     NF_CONNTRACK_BROADCAST 
> >   - changed nf_conntrack_broadcast.c copyright message
> 
> I've applied the patch after fixeing up a few minor issues (does not
> build with NF_CONNTRACK=m) by adding a MODULE_LICENSE and changing the
> Kconfig bool to a tristate.
> 
> The final patch is attached to this email.

cool :) thanks a lot

jirka
