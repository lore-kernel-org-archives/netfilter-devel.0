From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: DNAT dosen't work
Date: Sat, 11 Oct 2003 22:20:00 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310112216510.14382-100000@filer.marasystems.com>
References: <wazza.87d6d3u8tb.fsf@message.id>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Slav Rilov <Slav.Rilov@Zoo.org>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laurent.ml@linuxfr.org
In-Reply-To: <wazza.87d6d3u8tb.fsf@message.id>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 11 Oct 2003 laurent.ml@linuxfr.org wrote:

> You should consider adding a FORWARD rule to let traffic go from eth1
> to 10.10.1.1(eth0)
> The correct mailing list for that kind of question is netfilter-user !

There is no FORWARD to local addresses. All addresses are global to all
interfaces, just associated with interfaces for routing of outgoing
packets and management purposes.

Regards
Henrik
