From: Pablo Neira <pablo@netfilter.org>
Subject: Re: buffer overflow in ip_ct_{ftp,tftp,irc}
Date: Tue, 20 Sep 2005 10:10:59 +0200
Message-ID: <432FC413.6020301@netfilter.org>
References: <431F7B26.4040302@netfilter.org>	<431F7C38.50206@netfilter.org>	<432213E5.4000200@trash.net>
	<200509200711.j8K7Bw3x002184@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	sbellabes@mandriva.com, kaber@trash.net, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200509200711.j8K7Bw3x002184@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Sat, 10 Sep 2005 00:59:49 +0200
> 
> 
>>>-static int ports[MAX_PORTS];
>>>+static short ports[MAX_PORTS];
>>>static int ports_c;
>>>-module_param_array(ports,int, &ports_c, 0400);
>>>+module_param_array(ports, short, &ports_c, 0400);
>>
>>I agree, I've applied this patch instead. Thanks.
> 
> 
> Why don't you use u_int16_t and ushort instead of short ?

Short reply, because the u_int16_t type isn't defined in moduleparam.h. 
See the param_set_* stuff.

--
Pablo
