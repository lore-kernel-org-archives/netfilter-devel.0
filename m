From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] extensions: libxt_dccp: Add translation to nft
Date: Mon, 7 Mar 2016 17:51:20 +0100
Message-ID: <20160307165120.GA29091@salvia>
References: <20160303220145.GA6872@gmail.com>
 <20160307143904.GA28237@salvia>
 <CAKHNQQG+=0mFAnzsq7ZEM8H8ON=0EfSrVrfMtY3i1DeRKheCyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40998 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbcCGQvf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 11:51:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 982D34B0F5
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 17:51:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 898D0DA380
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 17:51:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2A2E0DA380
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 17:51:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQG+=0mFAnzsq7ZEM8H8ON=0EfSrVrfMtY3i1DeRKheCyw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 07, 2016 at 10:13:51PM +0530, Shivani Bhardwaj wrote:
> On Mon, Mar 7, 2016 at 8:09 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Mar 04, 2016 at 03:31:45AM +0530, Shivani Bhardwaj wrote:
> >> Add translation for dccp to nftables.
> >>
> >> Full translation of this match awaits the support for --dccp-option.
> >>
> >> Examples:
> >>
> >> $ sudo iptables-translate -A INPUT -p dccp -m dccp --sport 100
> >> nft add rule ip filter INPUT dccp sport 100 counter
> >>
> >> $ sudo iptables-translate -A INPUT -p dccp -m dccp --dport 100:200
> >> nft add rule ip filter INPUT dccp dport 100-200 counter
> >>
> >> $ sudo iptables-translate -A INPUT -p dccp -m dccp ! --dport 100
> >> nft add rule ip filter INPUT dccp dport != 100 counter
> >>
> >> $ sudo iptables-translate -A INPUT -p dccp -m dccp --dport 100 --dccp-types REQUEST,RESPONSE,DATA,ACK,DATAACK,CLOSEREQ,CLOSE,SYNC,SYNCACK
> >> nft add rule ip filter INPUT dccp dport 100 dccp type {request, response, data, ack, dataack, closereq, close, sync, syncack} counter
> >>
> >> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> >> ---
> >> Changes in v3:
> >>       Return 0 if translation for dccp-option is demanded
> >>
> >> Changes in v2:
> >>         Fix bugs and remove invalid dccp type
> >>
> >> Following is not added in commit message as it is not translation code
> >> issue:
> >> * Since inversion of set is not possible in nftables, using dccp
> >> with rules like
> >> ...dccp type != {request, response}..
> >> * dccp type reset
> >> is going to throw errors.
> >>
> >>  extensions/libxt_dccp.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 92 insertions(+)
> >>
> >> diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
> >> index a35cabb..0d4f369 100644
> >> --- a/extensions/libxt_dccp.c
> >> +++ b/extensions/libxt_dccp.c
> >> @@ -277,6 +277,97 @@ static void dccp_save(const void *ip, const struct xt_entry_match *match)
> >>       }
> >>  }
> >>
> >> +static const char *const dccp_pkt_types_xlate[] = {
> >> +     [DCCP_PKT_REQUEST]      = "request",
> >> +     [DCCP_PKT_RESPONSE]     = "response",
> >> +     [DCCP_PKT_DATA]         = "data",
> >> +     [DCCP_PKT_ACK]          = "ack",
> >> +     [DCCP_PKT_DATAACK]      = "dataack",
> >> +     [DCCP_PKT_CLOSEREQ]     = "closereq",
> >> +     [DCCP_PKT_CLOSE]        = "close",
> >> +     [DCCP_PKT_RESET]        = "reset",
> >> +     [DCCP_PKT_SYNC]         = "sync",
> >> +     [DCCP_PKT_SYNCACK]      = "syncack",
> >> +};
> >> +
> >> +static int dccp_type_xlate(const struct xt_dccp_info *einfo,
> >> +                        struct xt_xlate *xl)
> >> +{
> >> +     bool have_type = false, set_need = false;
> >> +     uint16_t types = einfo->typemask;
> >> +
> >> +     if (types & (1 << DCCP_PKT_INVALID))
> >> +             return 0;
> >> +
> >> +     xt_xlate_add(xl, "dccp type%s ", einfo->invflags ? " !=" : "");
> >> +
> >> +     if ((types != 0) && !(types == (types & -types))) {
> >> +             xt_xlate_add(xl, "{");
> >> +             set_need = true;
> >> +     }
> >> +
> >> +     while (types) {
> >> +             unsigned int i;
> >> +
> >> +             for (i = 0; !(types & (1 << i)); i++);
> >> +
> >> +             if (have_type)
> >> +                     xt_xlate_add(xl, ", ");
> >> +             else
> >> +                     have_type = true;
> >> +
> >> +             xt_xlate_add(xl, "%s", dccp_pkt_types_xlate[i]);
> >> +
> >> +             types &= ~(1 << i);
> >> +     }
> >> +
> >> +     if (set_need)
> >> +             xt_xlate_add(xl, "}");
> >> +
> >> +     xt_xlate_add(xl, " ");
> >> +
> >> +     return 1;
> >> +}
> >> +
> >> +static int dccp_xlate(const struct xt_entry_match *match,
> >> +                   struct xt_xlate *xl, int numeric)
> >> +{
> >> +     const struct xt_dccp_info *einfo =
> >> +                     (const struct xt_dccp_info *)match->data;
> >> +     int ret = 1;
> >> +
> >> +     xt_xlate_add(xl, "dccp ");
> >> +
> >> +     if (einfo->flags & XT_DCCP_SRC_PORTS) {
> >> +             if (einfo->spts[0] != einfo->spts[1])
> >> +                     xt_xlate_add(xl, "sport%s %u-%u ",
> >> +                                  einfo->invflags & XT_DCCP_SRC_PORTS ? " !=" : "",
> >> +                                  einfo->spts[0], einfo->spts[1]);
> >> +             else
> >> +                     xt_xlate_add(xl, "sport%s %u ",
> >> +                                  einfo->invflags & XT_DCCP_SRC_PORTS ? " !=" : "",
> >> +                                  einfo->spts[0]);
> >> +     }
> >> +
> >> +     if (einfo->flags & XT_DCCP_DEST_PORTS) {
> >> +             if (einfo->dpts[0] != einfo->dpts[1])
> >> +                     xt_xlate_add(xl, "dport%s %u-%u ",
> >> +                                  einfo->invflags & XT_DCCP_DEST_PORTS ? " !=" : "",
> >> +                                  einfo->dpts[0], einfo->dpts[1]);
> >> +             else
> >> +                     xt_xlate_add(xl, "dport%s %u ",
> >> +                                  einfo->invflags & XT_DCCP_DEST_PORTS ? " !=" : "",
> >> +                                  einfo->dpts[0]);
> >> +     }
> >> +
> >> +     if (einfo->flags & XT_DCCP_TYPE)
> >> +             ret = dccp_type_xlate(einfo, xl);
> >> +
> >> +     if (einfo->flags & XT_DCCP_OPTION)
> >> +             ret = 0;
> >
> > Shouldn't you check fot this XT_DCCP_OPTION in first place?
> >
> > Or you achieve the same effect? I don't remember how this is behaving
> > when we already translated many things but just one thing got left
> > behind.
> >
> This gives the same effect.
> 
> $ sudo iptables-translate -A INPUT -p dccp -m dccp --sport 100 --dccp-option 1
> nft # -A INPUT -p dccp -m dccp --sport 100 --dccp-option 1
> 
> Please let me know if you're referring to something else.

That's good then. Applied, thanks.
