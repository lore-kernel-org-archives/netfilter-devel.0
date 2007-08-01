From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ipset merge
Date: Wed, 01 Aug 2007 11:07:07 +0200
Message-ID: <46B04D3B.6090706@netfilter.org>
References: <Pine.LNX.4.64.0708011057060.26668@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net, kadlec@blackhole.kfki.hu
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708011057060.26668@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> I was wondering whether there are any obstacles to merge ipset into 
> mainline - for example, it being too much of a hack like ipt_ROUTE was.
> Otherwise, I'd like to prepare and submit it.

It must use the new nfnetlink infrastructure. Jozsef is currently
working on that. I wanted to have a look at it but I have had not time
so far.

-- 
"Será preciso viajar a través de los ojos de los idiotas" -- Poeta en
Nueva York -- Federico García Lorca.
