From: "Sverker Abrahamsson" <sverker@abrahamsson.com>
Subject: Re: rtsp conntrack compilation error 2.6.18
Date: Wed, 24 Jan 2007 17:54:13 +0100
Message-ID: <1f7f01c73fd8$4ede0f10$c202010a@Fiona>
References: <loom.20061225T094953-80@post.gmane.org>
	<45A48342.1050601@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-15";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>,
	"F Helmer" <netfilter.20.fhelmer@spamgourmet.com>
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

I've been thinking many times to update the rtsp conntrack patch but where 
can I find information about changes in the API (except for reading diff's)? 
Are there any maintained API doc for netfilter?
/Sverker

----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "F Helmer" <netfilter.20.fhelmer@spamgourmet.com>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Wednesday, January 10, 2007 7:10 AM
Subject: Re: rtsp conntrack compilation error 2.6.18


>F Helmer wrote:
>> Hello
>>
>> I am not sure if this is the correct group to post to?
>>
>> I am trying to patch my 2.6.18 kernel (latest pom using svn + runme 
>> extra)
>> and I
>> get the following compilation error:
>>
>>  CC [M]  net/ipv4/netfilter/ip_conntrack_netlink.o
>>  CC [M]  net/ipv4/netfilter/ip_conntrack_proto_sctp.o
>>  CC [M]  net/ipv4/netfilter/ip_conntrack_rtsp.o
>> net/ipv4/netfilter/ip_conntrack_rtsp.c: In function 'help_out':
>> net/ipv4/netfilter/ip_conntrack_rtsp.c:340: error: too few arguments
>> to function
>> 'ip_conntrack_expect_alloc'
>> net/ipv4/netfilter/ip_conntrack_rtsp.c:371: warning: implicit declaration 
>> of
>> function 'ip_conntrack_expect_free'
>> make[4]: *** [net/ipv4/netfilter/ip_conntrack_rtsp.o] Error 1
>> make[3]: *** [net/ipv4/netfilter] Error 2
>> make[2]: *** [net/ipv4] Error 2
>> make[1]: *** [net] Error 2
>> make[1]: Leaving directory `/usr/src/linux-source-2.6.18'
>> make: *** [debian/stamp-build-kernel] Error 2
>> fredrikh@helmer:/usr/src/linux$
>>
>> Do you happen to know what I am doing wrong? Or is there a "better"
>> patch somewhere?
>
>
> The patch needs to be updated to work with current kernels. Its
> not actively maintained, so you'll probably have to do it yourself.
>
>
> 
