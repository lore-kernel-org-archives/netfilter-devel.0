From: Joubert Berger <jberger@trustednetworktech.com>
Subject: understanding how nf_bridge_maybe_copy_header works
Date: Fri, 25 Jun 2004 14:28:41 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1088188121.3628.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>, Ebtables Developers <ebtables-devel@lists.sourceforge.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Sorry for the crosspost, but I was not sure which list this question
would apply to.

I am having some difficulty understanding something and I was hoping
that someone can shed some light on the subject for me.

In the br_dev_queue_push_xmit() routine a call is made to
nf_bridge_maybe_copy_header(), which seems to copy information from
skb->nf_bridge->data to the skb->data.  This will happen when in being
used by the bridge.  But, I can't seem to figure out how this data is
copied into the skb->nf_bridge->data in the first place.  If you follow
the code in the br_netfilter.c file for VLAN frames, I never see how
skb->nf_bridge->data is set, yet it seems to copy the data from there. 
So, I am missing something.  But, I can't seem to figure out what it
is?  Can anyone help me?  Thanks in advance.

--joubert   
