From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC NETFILTER 2/2]: Add NetBIOS name service helper
Date: Sun, 04 Sep 2005 17:51:39 +0200
Message-ID: <431B180B.1060505@trash.net>
References: <431ADF56.2050000@trash.net> <20050904154016.GA25949@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050904154016.GA25949@linuxace.com>
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

Phil Oester wrote:
> On Sun, Sep 04, 2005 at 01:49:42PM +0200, Patrick McHardy wrote:
> 
>>+	  NetBIOS name service requests are sent as broadcast message from an
> 
>   +	  NetBIOS name service requests are sent as broadcast messages from an
> 
> 
>>+	  unpriviledged port and responded to with unicast messages to the
> 
>   +	  unprivileged port and responded to with unicast messages to the
> 
> 
>>+ *      requests by issueing permanent expectations (valid until
> 
>   + *      requests by issuing permanent expectations (valid until
> 
> 
>>+ *      timeing out) matching all reply connections from the
> 
>   + *      timing out) matching all reply connections from the

Fixed, thanks Phil.
