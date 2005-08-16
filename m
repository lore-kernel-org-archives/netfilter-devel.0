From: Patrick McHardy <kaber@trash.net>
Subject: Re: error : unable to register queue handler
Date: Tue, 16 Aug 2005 18:45:07 +0200
Message-ID: <43021813.1030209@trash.net>
References: <twig.1124014287.15909@cdac.in>
	<Pine.LNX.4.61.0508161840400.16354@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0508161840400.16354@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
>>I am having problem with inserting a module . It has compiled well but on
>>insertion (insmod) error message "failed to register queue handler" is
> 
> (modprobe)!

There can be only one queue handler for each protocol. so the solution
is to make sure no other modules have registered. Most likely you
need to disable ip_queue.
