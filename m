From: Philip Craig <philipc@snapgear.com>
Subject: Re: Libnetfilter_conntrack problems
Date: Fri, 12 May 2006 18:42:07 +1000
Message-ID: <44644A5F.1010504@snapgear.com>
References: <ca021ab30604270455q5cf093c9s990558209bca3e1d@mail.gmail.com>	<20060501175353.GD5267@rama>	<ca021ab30605030249s62ab1924uf9b1be924bd2d28e@mail.gmail.com>	<20060503111549.GO16562@sunbeam.de.gnumonks.org>	<ca021ab30605090806l791e6f3dl7354bd789df209ee@mail.gmail.com>	<4460B14E.90506@eurodev.net>	<ca021ab30605100118u16675c7au933a464ebe64d705@mail.gmail.com>	<ca021ab30605100600k5bfbe4faob771b62d50e35575@mail.gmail.com>
	<ca021ab30605120134p552496f3i5ebd2f7c0a05b191@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, Pablo Neira Ayuso <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-1?Q?S=E9bastien_LAVEZE?= <slaveze@gmail.com>
In-Reply-To: <ca021ab30605120134p552496f3i5ebd2f7c0a05b191@mail.gmail.com>
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

On 05/12/2006 06:34 PM, S=E9bastien LAVEZE wrote:
> But if i do conntrack -E -e DESTROY
> I never get any events for the same connection as i did with the UPDATE=
 events

It's working for me using 2.6.16 on ARM and userspace from SVN.
Are you sure you are waiting 2 minutes for the timeout?
How about if you try pings?
