From: Henrik Nordstrom <henrik@marasystems.com>
Subject: Re: Buffer size
Date: Wed, 21 Jan 2004 09:45:12 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401210933580.3914-100000@filer.marasystems.com>
References: <400DE836.8050604@plobe.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: XiChimos <xichimos@plobe.com>
In-Reply-To: <400DE836.8050604@plobe.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 20 Jan 2004, XiChimos wrote:

> Well, basically one that contains the payload and IP header, which is 
> returned by ipq_read.  Basically my question is if I am casting the 
> payload of the ipq packet msg structure into a data-type, what is the 
> maximum size that this type should be?

The largest packet including payload you will be receiving. I think that
if you specify a smaller buffer then the pakets will be truncated which
may be acceptable if the application is only inspecting the headers and
beginning of protocol payload, but if you want to do packet modification
then you need the whole packet.

Regards
Henrik
