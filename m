From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: CONNMARK and state RELATED
Date: Wed, 3 Mar 2004 08:39:01 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403030836030.3365-100000@filer.marasystems.com>
References: <7C9884991ADAE0479C14F10C858BCDF56791B5@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter developmnet mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel Chemko <dchemko@smgtec.com>
In-Reply-To: <7C9884991ADAE0479C14F10C858BCDF56791B5@alderaan.smgtec.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2 Mar 2004, Daniel Chemko wrote:

> I am using CONNMARK to do policy routing. I use it to select which WAN
> interface the packet will leave the system. It seems that CONNMARK
> doesn't mark related traffic. This makes it very hard to implement what
> I am trying to do.

It does, but you must remember to have the connmark restored into the 
packet if you want to use it for routing, this is not automatic. Applies 
to both normal and related traffic.

> ${IPTABLES} -t mangle -A PREROUTING --source ${_fip} --destination
> ${_sip} -p ${_proto} -j CONNMARK --set-mark ${_fwmark} -m mark --mark 0

This rule only sets the connmark value, not the per-packet packet mark.

Regards
Henrik
