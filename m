From: Padraig@Linux.ie
Subject: maintaining per rule counters
Date: Thu, 10 Apr 2003 16:02:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E958792.8040501@Linux.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi I'm afraid I can't subscribe to the mailing list at present?

Anyway I have a fairly simple requirement to maintain per
rule packet & byte counts that are timestamped and sent
to userspace every 1ms (packet clocked).

My question is where is the best place to store the 1ms of counters.
Can I create a target module and put the data in the *targinfo
I.E. is targinfo global to the target module or per rule.
The ideal would be if it was dynamically allocated per rule and
was just big enough for my counters+timestamp. What determines
the size?

cheers,
P=E1draig.
