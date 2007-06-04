From: "Eric Leblond" <eric@inl.fr>
Subject: Re: Bug in conntrack -U
Date: Mon, 4 Jun 2007 18:05:18 +0200 (CEST)
Message-ID: <36058.193.251.55.235.1180973118.squirrel@mail.inl.fr>
References: <1180707433.4733.7.camel@ghlodit.inl.fr>
	<4663E267.1030900@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org, Eric Leblond <eric@inl.fr>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4663E267.1030900@netfilter.org>
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

> Eric Leblond wrote:
>> I've found a problem with conntrack-tools. Running :
>> conntrack -U -m 20 -s 192.168.50.140 -d 192.168.50.129 -p tcp
>> --orig-port-src 43515 --orig-port-dst 22
>> returns
>
> The problem seems to be in libnetfilter_conntrack. The patch attached
> should fix the problem. Thanks for the report.

It works great ! Good work from you as usual !

BR,
--
Eric
