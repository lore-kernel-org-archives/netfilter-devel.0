From: "Kevin P. Fleming" <kpfleming@starnetworks.us>
Subject: Re: Changing the Ethernet header
Date: Thu, 17 Feb 2005 22:43:12 -0700
Message-ID: <42158070.2090104@starnetworks.us>
References: <7DC268DDBA95E14D8572DF824F92789E03EE5D@gn-ex01.Go80211.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
In-Reply-To: <7DC268DDBA95E14D8572DF824F92789E03EE5D@gn-ex01.Go80211.com>
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

Gil Shai wrote:

> I am trying to create a rule that causes packets going to a certain IP
> to have a certain VLAN header.

So create a VLAN interface, bind an address to it, and add a host route 
for that IP to go out via that interface.
