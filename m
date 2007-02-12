From: "Essien Essien" <essiene@gmail.com>
Subject: libnetfilter_queue examples/test suite
Date: Mon, 12 Feb 2007 16:53:20 +0100
Message-ID: <88b82c90702120753v19e1a4f4rc96f041fa0adf5bb@mail.gmail.com>
References: <88b82c90702120749s3c462c38t23857c08a55f87a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <88b82c90702120749s3c462c38t23857c08a55f87a7@mail.gmail.com>
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

Hi,

I'm creating bindings in D (http://www.digitalmars.com/d) for
libnetfilter_queue as part of an experiment to enable doing more
low-level Linux network hacking in D.

If successfull, I hope to expand this bindings to cover other parts of
Linux Networking Userspace hacking.

I've just started, but to check my correctness, I'd love for to
excercise it with existing libnetfilter_queue test suite. If no such
beast exists, I'd actually still find usefull any collection of
libnetfilter_queue codes that are known to be working. Basically, any
code that uses libnetfilter_queue.  /The plan is to translate them and
test correctness of the library. Anyone having even trivial samples or
extremely complex libnetfilter_queue-FU code, please either inline the
smaller examples and send to the mailing list, or send bigger files
directly to essiene@gmail.com

Cheers and thanks,
Essien
