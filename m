From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix hang on netfilter module unload
Date: Tue, 15 Mar 2005 22:48:15 +0100
Message-ID: <4237581F.30007@trash.net>
References: <20050315050641.GA334@linuxace.com>	<20050315172330.GA3130@linuxace.com>	<4237369D.8080408@trash.net>	<20050315194602.GA3487@linuxace.com>	<42373D55.8020005@trash.net>
	<4237410F.2080207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <4237410F.2080207@trash.net>
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

Patrick McHardy wrote:
> Patrick McHardy wrote:
> 
>> I don't think it is related to the specific application.
>> More likely the packet is queued while the device is down
>> and never dequeued. Does this patch fix the problem ?
> 
> 
> Actually this can't happen since dev_deactivate switches the
> qdisc with a noop_qdisc when the device is set down.

Could you try it anyway ? It will help narrow down the
area where this leak happens.

Regards
Patrick
