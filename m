From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: mask for interface
Date: Thu, 25 Mar 2004 12:46:07 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403251241430.14618-100000@filer.marasystems.com>
References: <40629EB1.4080005@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur AKAN <akan@aiqa.com>
In-Reply-To: <40629EB1.4080005@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 25 Mar 2004, Ozgur AKAN wrote:

> Hi,
> 
> in the code of "struct ipt_ip" there is a mask value for the interface. 
> I can understand mask for an ip address but can not understand mask 
> value for an interface. For example what can be the mask for eth0?

It is used for wildcards like eth+ or ppp+. The kernel actually supports
even more complex matches thanks to the masking but the iptables binary
don't have a syntax for specifyig other kinds of non-exact 
interface matches..

Regards
Henrik
