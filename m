From: Visham Ramsurrun <vishamr2000@gmail.com>
Subject: HElp with script execution!!
Date: Wed, 27 Jul 2005 15:11:07 +0400
Message-ID: <9927912d05072704113d7e8707@mail.gmail.com>
Reply-To: Visham Ramsurrun <vishamr2000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi to all,

I wanted to ask if it is possible to get a signal (i don't know from
where, maybe a function in the kernel or from the NIC) just before
every packet is sent out the NIC. The signal then causes a script to
execute. I basically want to execute a script on a per-packet basis.
But I don't know how to go about it. I thought about the QUEUE target
but i'm not sure. What things I should be looking at?

Thx in advance..

Warm regards,
Visham
