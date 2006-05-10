From: "=?ISO-8859-1?Q?S=E9bastien_LAVEZE?=" <slaveze@gmail.com>
Subject: Re: Libnetfilter_conntrack problems
Date: Wed, 10 May 2006 15:00:20 +0200
Message-ID: <ca021ab30605100600k5bfbe4faob771b62d50e35575@mail.gmail.com>
References: <ca021ab30604270455q5cf093c9s990558209bca3e1d@mail.gmail.com>
	<20060501175353.GD5267@rama>
	<ca021ab30605030249s62ab1924uf9b1be924bd2d28e@mail.gmail.com>
	<20060503111549.GO16562@sunbeam.de.gnumonks.org>
	<ca021ab30605090806l791e6f3dl7354bd789df209ee@mail.gmail.com>
	<4460B14E.90506@eurodev.net>
	<ca021ab30605100118u16675c7au933a464ebe64d705@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pablo Neira Ayuso" <pablo@eurodev.net>
In-Reply-To: <ca021ab30605100118u16675c7au933a464ebe64d705@mail.gmail.com>
Content-Disposition: inline
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

I guess the problem is having two event handles on two different
processes and this might cause some strange behaviour. (I also have
destroy events that come 5 mn after the expiration of the TIME_WAIT
timer...)
Has someone ever tried that ??
Maybe it should be safer to have only one process listening to ALL
events and then to dispatch them..
Is there a way to make the difference between UPDATE and DESTROY
events with a single callback listening to ALL different ?? (type
field maybe ?)

Thanks
Sebastian
