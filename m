From: =?ISO-8859-2?Q?Tom=E1=B9_Macek?= <maca02@atlas.cz>
Subject: Re: Unable to build iptables on linux kernel 2.6.10 + 2.6.11-rc2	+
 2.6.11-rc2-bk5
Date: Tue, 1 Feb 2005 08:04:52 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0502010804210.22907@maca.fortech.cz>
References: <200501271553.j0RFr747004108@StraightRunning.com>
	<41FD5F3C.1060009@eurodev.net> <20050201005133.GJ31837@postel.suug.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050201005133.GJ31837@postel.suug.ch>
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

Whats the exact difference between each of the possibilities?


On Tue, 1 Feb 2005, Thomas Graf wrote:

>>  		/* The protocol. */
>> -		u8 protonum;
>> +		u_int8_t protonum;
>>
>>  		/* The direction (for tuplehash) */
>> -		u8 dir;
>> +		u_int8_t dir;
>
> I think __u8 would be a better choice.
>
>
>
>
>
>
>
