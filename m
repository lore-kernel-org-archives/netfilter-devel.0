From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: Re: H.323 behavior
Date: Thu, 31 May 2007 07:30:23 -0400
Message-ID: <BAY139-DAV1488834AE2E507BE9E4BDFB32D0@phx.gbl>
References: <925A849792280C4E80C5461017A4B8A210B7F8@mail733.InfraSupportEtc.com>
	<465E506D.6060008@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="ISO-8859-15";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>,
	"Greg Scott" <GregScott@InfraSupportEtc.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Greg Scott" <GregScott@InfraSupportEtc.com>
Cc: <netfilter-devel@lists.netfilter.org>; "Jing Min Zhao" 
<zhaojingmin@users.sourceforge.net>
Sent: Thursday, May 31, 2007 12:34 AM
Subject: Re: H.323 behavior


> Greg Scott wrote:
>> Apologies - I never replied back to the list on how this turned out.
>> Jing Min Zhao was kind enough to reply privately and we developed a
>> theory. Jing was right.  The problem was, I had set up the Polycom codec
>> here to use fixed ports - a legacy from before Jing's H.323 module.  So
>> every time I hung up a call and tried again, the Polycom would try to
>> call using the same ports.  But the firewall hadn't cleared them yet and
>> that's why the strange behavior.  The cure - just get rid of fixed ports
>> on the Polycom codec and use it as delivered from the factory.
>
>
> It would probably make sense to destroy the connection when we seen
> a CloseLogicalChannel or CloseLogicalChannelAck message to deal with
> this kind of problem.
>

Sometimes when people change codec, for example, from voice to T.38 fax, 
they also close channels and open channels, but the H.245 connection doesn't 
diconnect. So better to wait for the connection disconnect itself or at 
least disconnect upon EndSessionCommand.
