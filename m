From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: accounting module design questions
Date: Fri, 9 Apr 2004 23:45:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404092345.23573.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

I'm currently developing a high performance accounting target module
for local networks. It scales pretty well from 8 bit (CLASS C) networks
to 24 bit (CLASS A) networks, consuming memory for active IPs only.
Data transfer from the kernel to userspace is done via get/setsockopt.
After I've polished the code a bit more, I'm going to release it into public.
(+ a userspace library for querying the data)

I've some design questions left I can't clear myself:

- Is it valid to modify target data in the checkentry function?
Accounting information can be stored in user-named tables. To avoid
a strcmp() for every packet, I convert the table name in target_checkentry
to a number and store it in the target information.
Is it allowed to modify the supplied target information from kernel space?
It doesn't crash or act strange so far, but I want to be on the safe side.

- When returning the data, I'm currently calling copy_to_user for every IP.
The space used for every IP entry is 20 bytes. I somehow imagine
copy_to_user is a very expensive function and shouldn't be called too often.
For 1000 active clients it would be called 1000 times copying 20 bytes
-> Not good

I thought about adding a small buffer of f.e. 4096 (PAGE_SIZE) bytes.
Once it's filled up, I'll call copy_to_user. Is there a better way to 
transfer the data to userspace? mmaping the data is not available, as some
of the data structures have pointers to other kernel space memory blocks.

Thanks in advance for any help.

Cheers,
Thomas

-- 
Intra2net AG
Moempelgarder Weg 8
72072 Tuebingen
Germany

Tel: +49-7071-56510-0
Fax: +49-7071-56510-50
thomas.jarosch@intra2net.com
http://www.intra2net.com
