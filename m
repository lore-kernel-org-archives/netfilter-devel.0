From: aton <aton@packetdropped.org>
Subject: Re: libnfnetlink.h include generates problems...
Date: Wed, 13 Jun 2007 11:09:55 +0200
Message-ID: <466FB463.2020801@packetdropped.org>
References: <466DC10A.50805@packetdropped.org> <466E770E.5020404@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <466E770E.5020404@netfilter.org>
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

Pablo Neira Ayuso schrieb:
> aton wrote:
>> in one of my programs, i include the following two files:
>>
>> #include <linux/netfilter.h>
>> #include <libnetfilter_queue/libnetfilter_queue.h>
>>
>> while a few of my header files include each other i get errors from
>> these nfqueue header:
>>
>> In file included from /usr/include/sys/uio.h:24,
>>                  from /usr/include/sys/socket.h:27,
>>                  from /usr/local/include/libnfnetlink/libnfnetlink.h:19,
>>                  from
>> /usr/local/include/libnetfilter_queue/libnetfilter_queue.h:16,
>>                  from misc.h:14,
>>                  from packeter.c:9:
>> /usr/include/sys/types.h:62: error: conflicting types for 'dev_t'
>> /usr/include/linux/types.h:27: error: previous declaration of 'dev_t'
>> was here
>> /usr/include/sys/types.h:72: error: conflicting types for 'mode_t'
>> /usr/include/linux/types.h:33: error: previous declaration of 'mode_t'
>> was here
>> /usr/include/sys/types.h:77: error: conflicting types for 'nlink_t'
>> /usr/include/linux/types.h:36: error: previous declaration of 'nlink_t'
>> was here
>> etc. etc.
>>
>> i talked to some guys from ##c on freenode, and they said, probably
>> libnfnetlink.h should not directly include linux/types.h
> 
> What version of libnfnetlink are you using? This problem is supposed to
> be fixed already in 0.0.25.
> 

i am using libnfnetlink-0.0.25 and libnetfilter_queue-0.0.13.
i compiled it myself and did not use the packaged version of the gentoo
portage system
