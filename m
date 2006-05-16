From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: Libnetfilter_conntrack problems
Date: Tue, 16 May 2006 12:52:35 +0200
Message-ID: <4469AEF3.6030508@eurodev.net>
References: <ca021ab30604270455q5cf093c9s990558209bca3e1d@mail.gmail.com>	<20060501175353.GD5267@rama>	<ca021ab30605030249s62ab1924uf9b1be924bd2d28e@mail.gmail.com>	<20060503111549.GO16562@sunbeam.de.gnumonks.org>	<ca021ab30605090806l791e6f3dl7354bd789df209ee@mail.gmail.com>	<4460B14E.90506@eurodev.net>	<ca021ab30605100118u16675c7au933a464ebe64d705@mail.gmail.com>	<ca021ab30605100600k5bfbe4faob771b62d50e35575@mail.gmail.com>	<ca021ab30605120134p552496f3i5ebd2f7c0a05b191@mail.gmail.com>	<44644A5F.1010504@snapgear.com>
	<ca021ab30605120201u535a5569t78bd78ea01cf5dd0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org, Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-1?Q?S=E9bastien_LAVEZE?= <slaveze@gmail.com>
In-Reply-To: <ca021ab30605120201u535a5569t78bd78ea01cf5dd0@mail.gmail.com>
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

Sébastien LAVEZE wrote:
>> It's working for me using 2.6.16 on ARM and userspace from SVN.
>> Are you sure you are waiting 2 minutes for the timeout?
>> How about if you try pings?
> 
> Ok
> I'm also using 2.6.16 kernel with latest SVN
> It works fine for LOCAL connection but not for FORWARDED connections
> I do get UPDATE events for forwarded connection but there are no
> DESTROY events for forwarded connections
> Same stuff for pings (OK for local, NO for forward)

Weird. I had problems with hardware lately, I had some time to set up
some UML stuff last night, I'll be having a look at this.

Please, could you pass me as much information as you can in order to
reproduce the problem? Thanks.

-- 
Pablo
