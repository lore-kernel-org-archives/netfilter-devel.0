From: Philip Craig <philipc@snapgear.com>
Subject: Re: PPTP connection tracking and NAT patches
Date: Thu, 27 Mar 2003 10:16:40 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E8242E8.3050609@snapgear.com>
References: <Pine.GSO.4.03.10303190516050.23211-100000@shemp.vdata.com> <20030326152047.GY21953@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Hall <hall@vdata.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Thu, Mar 20, 2003 at 03:32:46AM -0500, Jeff Hall wrote:
>>I was also having problems running a PoPToP server on the firewall server.
>>The reason turned out to be that I had not chosen CONFIG_IP_NF_NAT_LOCAL
>>thinking that I did not need to NAT my local connections since my local
>>machines IP was not the same as the IP I am using for NAT. It turns out that
>>even if a connection does not satisfy any NAT rule the helper function is
>>called in do_bindings. Without CONFIG_IP_NF_NAT_LOCAL set the helper function
>>was being called for DST manipulations but not for SRC manipulations. My
>>question to netfilter gurus is shouldn't the helper function be skipped if
>>the connection doesn't satisfy any NAT rule?
> 
> 
> Mh.  If we don't have any nat mappings, we shouldn't call the helper.

We use the TCP source port of the control channel for the call ID when
NATting.  For this to work, we have to NAT both forwarded and local
connections, otherwise there is a possibility of a call ID clash.
Since the original call ID is usually different from the TCP source
port, there will be a nat mapping for local connections, and the
helper needs to be called.  If we get reservation of call IDs, then
this behaviour can be changed.

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances
