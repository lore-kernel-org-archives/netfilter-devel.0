From: Patrick McHardy <kaber@trash.net>
Subject: Re: using netfilter with mpls
Date: Sun, 13 Jun 2004 22:04:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087157097.11287.16.camel@ws>
References: <026301c44e59$b892c9a0$248610ac@pc.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
In-Reply-To: <026301c44e59$b892c9a0$248610ac@pc.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-06-09 at 21:41, Muhammad R. Sami wrote:
> I am a newbee to netfilter. Can I use netfilter along with MPLS to
> identify packets with special payload and then set EXP bits to certain
> value in the MPLS header.

There is no MPLS match/target yet, but it should be easy to write one.
But iptables is not the best place because it would only see MPLS-tagged
IP packets.

Regards
Patrick


> regards
>  
> ------------
>  
> Muhammad R. Sami
> Research Assistant,
> Computer Engineering Department
> P.O.Box 354
> King Fahd University of Petroleum & Minerals
> Dhahran 31261
> Saudi Arabia.
> Tel: +96638601423
> Cell: +96657982951
> www.ccse.kfupm.edu.sa/sami
