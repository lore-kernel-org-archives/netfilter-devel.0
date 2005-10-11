From: =?ISO-8859-1?Q?S=E9bastien_Bernard?= <seb@frankengul.org>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 22:59:20 +0200
Message-ID: <434C27A8.5080403@frankengul.org>
References: <20051010164141.GG5627@rama> <434AE1A0.5030400@frankengul.org>
	<20051011142347.GB4756@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051011142347.GB4756@rama.de.gnumonks.org>
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

Harald Welte a =E9crit :

>On Mon, Oct 10, 2005 at 11:48:16PM +0200, S=E9bastien Bernard wrote:
> =20
>
>>>[snip]
>>>     =20
>>>
>>I tested this patch on my machine.
>>It ooops instantly in get_counters() from ip_tables.c.
>>   =20
>>
>
>Mh, can you capture the oops and send it?  I'm travelling and don't have
>access to any SMP box, so it's unlikely I will be able to resolve this
>alone.
> =20
>
What information do you need exactly ?
The oops can be tiresome to write down.
Is the stackdump enough or do you need register info ?

    Seb
