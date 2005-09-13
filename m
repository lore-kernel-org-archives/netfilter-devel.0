From: JC <bikkit@gmail.com>
Subject: Communication between kernel modules (what's the proper way?)
Date: Tue, 13 Sep 2005 18:30:50 +0100
Message-ID: <a60102c305091310302e9dc215@mail.gmail.com>
Reply-To: bikkit@gmail.com
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

Somewhat out of topic for the mailing list, but I guess the developers
here could advise me on the matter:

I have developed two modules that use hooks to manipulate packets, and
I wish for them to communicate with each other. The proper way to
communicate with userspace is by using ioctls. But what is a proper
way to use to pass data between the two modules, bearing in mind these
are my modules and I cant apply for a system call...?

regards,
Ioannis
