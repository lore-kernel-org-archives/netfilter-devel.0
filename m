From: Tim Vandermeersch <tim.vandermeersch@pandora.be>
Subject: Re: Develop a TCP P2P encrypt tool in Linux using netfilter?
Date: Sun, 01 Jun 2003 17:44:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EDA1F78.8070306@pandora.be>
References: <002101c32847$74f10f10$6842f2da@dellxp>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yong Li <sdssly@sina.com>
In-Reply-To: <002101c32847$74f10f10$6842f2da@dellxp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Yong Li wrote:

> Hello All,
> I want to develop a TCP packet encrypt tool in Linux. I need to modify
> the receiving/sending TCP data. Can I use netfilter? if so, is there
> any examples about the packet data modify?
> Thanks?

Take a look at the XOR patch.

Regards,
Tim
