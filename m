From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: Using nfmark
Date: Tue, 30 Nov 2004 16:40:25 -0500
Message-ID: <876ef97a041130134054e2f392@mail.gmail.com>
References: <1992A582-4311-11D9-9302-000A957B2B6C@inf.ufrgs.br>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Jung Drebes <drebes@inf.ufrgs.br>
In-Reply-To: <1992A582-4311-11D9-9302-000A957B2B6C@inf.ufrgs.br>
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

On Tue, 30 Nov 2004 18:47:50 -0200, Roberto Jung Drebes
<drebes@inf.ufrgs.br> wrote:
> My netfilter module creates some traffic using ip_rcv and
> ip_finish_output, and this traffic is also subject to my module, since
> it is registered in the NF_IP_PRE_ROUTING and NF_IP_POST_ROUTING hooks.
> I would like to test in my module if this traffic was created by itself
> (in which case it should be ignored) or not (should be processed), and
> so I am thinking of marking created packets with a magic number. Can I
> use nfmark for that? Are there any other netfilter modules that use it?

If you only need the distinction during local packet processing, then
you can use the nfmark field for that purpose. However, if you are
trying to mark packets that will leave the box and be destined for
another, then you can't use nfmark. nfmark is just a
netfilter-internal field used to mark packets for firewall/route
rule/traffic shaping classification during packet processing. That
field is not actually part of the packet that comes in/goes out on the
wire.

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
