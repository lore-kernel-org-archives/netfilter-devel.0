From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Fw: [PATCH 2.4.22] looseUDP support
Date: Thu, 15 Apr 2004 02:58:21 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404150253450.31850-100000@filer.marasystems.com>
References: <004001c42283$950d8d50$2901080a@askeysh.com.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Daniel Chemko <dchemko@smgtec.com>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: John Ho <john_ho@sh.askey.com.tw>
In-Reply-To: <004001c42283$950d8d50$2901080a@askeysh.com.cn>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 15 Apr 2004, John Ho wrote:

> Or, as Mr. Henrik mentioned, create a custom DNAT target for every
> online game protocol of this type? Because our device need to pass the
> Microsoft UPnP IGDtest suite and without the looseUDP support it will
> always fail at NAT traversal test group. Thanks.

You don't need one per protocol, just a simple one which consists of two 
targets

a) A "remember me" target which tells that traffic should now be NAT:ed 
into this station, used on outgoing sessions.

b) A DNAT type target using the information recorded by the "remember me" 
target to have incoming sesions forwarded to the selected "loose" 
forwarding station..

You only need full blown helpers if you want to support multiple clients 
on the inside of your gateway at the same time.

Regards
Henrik
