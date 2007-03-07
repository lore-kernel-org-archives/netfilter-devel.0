From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/7 parse attributes with nfattr_parse in
	nfnetlink_check_attribute
Date: Wed, 07 Mar 2007 11:43:32 +0100
Message-ID: <45EE9754.8040304@netfilter.org>
References: <45D0EE40.4050404@netfilter.org> <45D19B7A.5080305@trash.net>
	<20070306214527.GD521@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070306214527.GD521@postel.suug.ch>
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

Thomas Graf wrote:
> * Patrick McHardy <kaber@trash.net> 2007-02-13 12:05
>> Pablo Neira Ayuso wrote:
>> Currently other netlink subsystems return errors for the first level
>> of attributes and accept unknown attributes on deeper levels. I'm
>> not sure which I prefer, ignoring unknown attributes makes it
>> impossible for userspace to know that something isn't going to have
>> any effect, returning an error makes it harder to support new features.
>>
>> I know Thomas had intentions of increasing consistency in this area,
>> I'm just not sure in which direction :)
>>
>> Thomas, what do you think of this patch?
> 
> I believe that all unknown attributes should be ignored so recent
> userspace code can function on older kernels. That's the way I'm
> working towards.

Then I'll resend the patch if nobody objects anymore ;)

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
