From: "Archills Zhao" <archills_81@yahoo.com.cn>
Subject: To send a  skb  cloned in netfilter HOOK out
Date: Fri, 25 Feb 2005 10:36:40 +0800
Message-ID: <002a01c51ae2$de33b970$18a8a8c0@archills>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
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

Hi,

for example, to register a module in NF_IP_POST_ROUTING, in which skb =
was cloned and stored in my_skb,
If i want this cloned packet to follow the routine to finally be sent =
out,
where should i inject this "myskb"?how to realise this in network satck?

i have run into netfilter for just one or two week and found it really =
nice!


Brgds,
Archills
