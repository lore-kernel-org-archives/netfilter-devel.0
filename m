From: caster@postech.ac.kr
Subject: [Q]what is the net_ratelimit() ?
Date: Fri, 20 Dec 2002 11:26:39 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <CKEGJOPDOMNNFIGIMICAGENDCCAA.caster@postech.ac.kr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Must  every printk messages in network BH  use net_ratelimit?
is it effective when every traffic in netfilter rule needs printk message?
