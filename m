From: Patrick McHardy <kaber@trash.net>
Subject: Re: POSSIBLE BUG:  netfilter/ip_conntrack_core
Date: Mon, 16 Feb 2004 16:12:07 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4030DDC7.4050900@trash.net>
References: <4030DADD.1040104@rttx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peter Grace <pgrace@rttx.com>
In-Reply-To: <4030DADD.1040104@rttx.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Peter Grace wrote:
> Hello,
> ~    I'm posting to the list blindly this following report:

Moved from linux-kernel to netfilter-devel ..

> 
> LIST_DELETE: net/ipv4/netfilter/ip_conntrack_core.c:295
> &ct->tuplehash[IP_CT_DIR_REPLY] (c40bf384) not in &ip_conntrack_hash[hr]
> 
> I believe the memory addresses are not as pertinent as the message
> itself, but the screen filled up with 4-5 of these lines before finally
> biting the dust.
> 
> Can someone shoot me an e-mail in reply to let me know if this is a bug
> in netfilter code or if I'm just somehow confusing the heck out of the
> nat filter?  I've got a set of nat forwarding rules that forwards an ip
> address onto the internal lan, and then from there I'm only allowing
> certain packets to go through -- that seems to have exacerbated the
> problem..

Please post your ruleset, your kernel version and other relevent
information, this should not happen.

Regards
Patrick


> 
> Thanks in advance!
> 
> Pete
> 
> --
> ---
> /------------------------------------------------\
> |Peter Grace                  Phone: 484-875-9462
> |Technology Analyst             Fax: 484-875-9461
> |RealTime Technologies, Inc.   Cell: 484-919-1400
> |835 Springdale Drive, Suite 101
> |Exton, PA  19341
> \------------------------------------------------/

