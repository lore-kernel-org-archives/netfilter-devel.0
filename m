From: Fabrice MARIE <fabrice@celestix.com>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Fri, 5 Jul 2002 12:01:21 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207051201.21457.fabrice@celestix.com>
References: <20020702142447.GI18333@naboo.rchrd.phub.net.cable.rogers.com> <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu> <20020704235831.GO20357@naboo.ists.dartmouth.edu>
Reply-To: fabrice@celestix.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <20020704235831.GO20357@naboo.ists.dartmouth.edu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello Harald,

On Friday 05 July 2002 07:58, Harald Welte wrote:
> [...]
> yes. But then, how do we distinguish between terminating targets [where
> we can have only one per rule] and non-terminating targets AKA actions,
> where we can have multiple.

You could just add a boolean field 'terminating' to the iptables_target.
Then, make sure iptables abort and complains if it sees more than one terminating
target being requested in a single rule.

Iptables could even give a warning (and reorder on the fly if necessary) if a
terminating target is found before a non-terminating target.

For example, the iptables_target struct of the TTL target would become :

static
struct iptables_target TTL = { NULL,
        "TTL",
        IPTABLES_VERSION,
        IPT_ALIGN(sizeof(struct ipt_TTL_info)),
        IPT_ALIGN(sizeof(struct ipt_TTL_info)),
        &help,
        &init,
        &parse,
        &final_check,
        &print,
        &save,
-       opts
+       opts,
+       0 /* target is NOT terminating*/
};

and the iptables_target struct of the REJECT target would become :

static
struct iptables_target reject
= { NULL,
    "REJECT",
    IPTABLES_VERSION,
    IPT_ALIGN(sizeof(struct ipt_reject_info)),
    IPT_ALIGN(sizeof(struct ipt_reject_info)),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
-   opts
+   opts,
+   1 /* target is terminating */
};

But now, if you don't want to use the match piggybacking trick that Jozsef & Henrik
mentionned, then we can't implement that right now.
Do you think multiple targets is worth including in the design of the next
netfilter framework ?

I bielieve we should do that, multiple actions for one condition is very natural,
and I believe the usage of a custom chain for each of theses rules is a bit overkill..

Any thoughts ?

Fabrice.
--
Fabrice MARIE
Senior R&D Engineer
Celestix Networks
http://www.celestix.com/

"Silly hacker, root is for administrators"
       -Unknown
