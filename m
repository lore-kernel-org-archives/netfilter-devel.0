From: "VeNoMouS" <venom@gen-x.co.nz>
Subject: iptables
Date: Mon, 9 Feb 2004 17:48:42 +1300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <015201c3eec8$0728f360$5746370a@nsp.co.nz>
References: <20040205052840.10884.25667.Mailman@netfilter-sponsored-by.noris.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

why does the iptc not account for the traffic in input/output for packets
that it has forwarded when you itpables -nxvL

ie: say our masq network is x.x.x.x/24 but our external ip is a.a.a.a any
data bound for or from  x.x.x.x/24 does not get allocated onto a.a.a.a.a why
is that, even tho in effect it is actally bound for the external ip first.
