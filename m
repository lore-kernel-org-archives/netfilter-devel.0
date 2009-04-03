From: Till Kamppeter <till.kamppeter@gmail.com>
Subject: Google Summer of Code 2009: Student application for the project "Optimized
 netfilter implementation"
Date: Fri, 03 Apr 2009 20:40:11 +0200
Message-ID: <49D6580B.3060202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:47286 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479AbZDCSkS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:40:18 -0400
Received: by bwz17 with SMTP id 17so1085905bwz.37
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Apr 2009 11:40:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

the GSoC student project

    Optimized netfilter implementation

is listed on the project ideas list of the Linux Foundation:

https://www.linuxfoundation.org/en/Google_Summer_of_Code_2009

In less than half an hour the application period for students will end=20
and there is one student application for this project currently (see be=
low).

If someone of you wants to mentor this student or at least communicate=20
with him and help evaluating his application, please sign up as a mento=
r=20
on http://socghop.appspot.com/ (this does not oblige you to actually=20
mentor a student) and select the Linux Foundation (organization link ID=
:=20
LF) as the mentoring organization. If you do so, you can still be a=20
mentor or admin at other orgs in parallel but not apply as a student an=
y=20
more.

=46or internal communication and ranking the student add private commen=
ts=20
to the application, to communicate with the student add public comments=
=2E

    Till

-----------------------------------------------------------------------=
-

Title:  	 Optimized netfilter implementation
Student: 	Shreyas Bhatewara
Mentor: 	No mentor assigned
Possible Mentors: 	None
Abstract:
netfilter is used for packet filtering and mangling and thus is used to=
=20
implement firewalls. Since every packet passing networking stack must b=
e=20
processed by netfilter it is extremely important to ensure that this=20
code is not the bottleneck of the pipeline. This project will attempt t=
o=20
improve the packet classification in netfilter in order to improve its=20
performance. The project will strive at understanding expensive=20
operations in packet filtering and suggest optimized improvements for=20
the same
Content:

     * Name  : Shreyas N Bhatewara
     * University / current enrollment  : University of Texas at Dallas
     * Short bio / overview of your background  :

I completed my bachelor in Computer Engineering from University of Pune=
=2E=20
I got quite interested in Linux and kernel programming during my senior=
=20
year project (Driver verifier and Fault injection test harness for=20
Linux). After completion of bachelor degree I worked for a couple of=20
years in area of networking, systems, Linux/Solaris kernel, Device=20
driver development, C and C++. I got to work on many interesting=20
projects during this time=20
(http://utdallas.edu/~snb071000/profession.html). Most of the=20
development was for clients of the company. I started my Masters in=20
Computer Science in Fall 2007. I was an intern at VMware for 7 months i=
n=20
2008. I learned a lot their and enjoyed my work thoroughly.

     * Tell us your IRC nick with which you will use the group's IRC=20
channel  : shreyasbforu
     * Your Coding Skills :

My coding skill set include the following:

Programming Languages: C, C++, Java, SQL(Oracle), COBOL, Lisp, ML,=20
Prolog, VC++, HTML, DHTML, XML, ASP, PHP, J2EE

Scripting: shell script, awk, sed, javascript

Tools: Wireshark, Dtrace, SVN/CVS/Perforce systems, GNU make and system=
,=20
iperf, netperf

Microprocessor arch.: i386, 8085, 8086, 80386, 8051 Micro controller.

Operating Systems: MS- DOS, Unix. Linux and Solaris =E2=80=93 Kernel an=
d user=20
space programming.

=46ields of Interests: Computer Networks, Distributed/Cluster Computing=
,=20
Operating Systems, High performance computing and storage.



In your application let us know

     * What platform do you use to code? Hardware specifications and=20
operating system :

I used to code in C, C++. For Intel architectures (32 and 64 bit). For=20
Linux and Solaris OSs.

     * Did you ever code in C or C++/Perl/python/..., yes/no? what is=20
your experience?

Yes I have coded in C/C++ for more than 8 years. (3 years=20
professionally, others academically).

I have not coded much in Perl/python, I learned them once though.

     * If you apply for a project on our ideas list, have you experienc=
e=20
in the areas listed under "Desired knowledge"?

Yes, I do have the desired knowledge (C, netfilter/iptables, Linux=20
kernel, build system) for this project.

Set yourself up

     * Set up your platform to build a Bazaar/GIT/Subversion snapshot o=
f=20
the current state of the project you are interested in.
     * If you need help, ask on the mailing list of the appropriate=20
group, or in the IRC.
     * Report success on the mailing list or IRC.

You and Us

     * Were you involved in development in the project's group in the=20
past? What was your contribution?

No, I was not.

     * Were you involved in other OpenSource development projects in th=
e=20
past? which, when and in what role?

No, I was not. This will be my first time.

     * Why have you chosen your development idea and what do you expect=
=20
from your implementation?

Performance optimization has always enticed me. I have spent a lot of=20
time optimizing a Solaris NIC device driver which I had ported from=20
Linux. I used Dtrace, lockstat and other tools for profiling. I did=20
quite a good job at it. I have also taken courses related to synthesis,=
=20
optimization and computer networking in my Masters program. I am hoping=
=20
to apply some knowledge from those courses too.

Secondly I know much about Linux networking stack to have a comfort=20
level for this project. I am confident that I will get upto speed and=20
conclusively complete this project.

I need not even mention this but at the basic I expect from my=20
implementation not to break anything which exists right now. I will tes=
t=20
thoroughly to ensure so. Further I expect to find faster alternatives t=
o=20
current packet classification code. May be multiple filtering rules can=
=20
be combined in some efficient way. I expect to improve the performance=20
of net filters



Your Project

     * What do you want to achieve?

I expect to find faster alternatives to current packet classification=20
code. May be multiple filtering rules can be combined in some efficient=
=20
way. I expect to improve the performance of netfilters when multiple=20
rules are applied at the same time. If there is some syntactic/semantic=
=20
redundancy of operations being performed to apply these rules, I will=20
try to eliminate it.

     * If you have chosen an idea from our list, why did you choose thi=
s=20
specific idea?

Performance optimization has always enticed me. I have spent a lot of=20
time optimizing a Solaris NIC device driver which I had ported from=20
Linux. I used Dtrace, lockstat and other tools for profiling. I did=20
quite a good job at it. I have also taken courses related to synthesis,=
=20
optimization and computer networking in my Masters program. I am hoping=
=20
to apply some knowledge from those courses too.

Secondly I know much about Linux networking stack to have a comfort=20
level for this project. I am confident that I will get upto speed and=20
conclusively complete this project.

     * What makes you suited to carry the project?

My past experience in working with similar projects, my educational=20
background and my enthusiasm for the work at hand makes me a good=20
candidate for this project. Although I do not know how exactly I can=20
improve the netfilter performance as of now, I think I am in good=20
position to understand and propose a solution to the problem during the=
=20
project. I understand how open source communities work, and what role a=
n=20
individual developer plays. I also understand the high quality of code=20
required to get into the code base.

     * How much time do you plan to invest in the project before, durin=
g=20
and after the Summer of Code (We expect full time 40h/week during GSoC,=
=20
but better make this explicit)?

I expect to invest 40 hours or more during the project. Even after the=20
end of the project I will strive to be answerable to the suggested=20
changes and if possible get the code into the main tree. I look forward=
=20
to this project as an opportunity to start working for an open source=20
community for a long term.

     * Please provide a schedule of how this time will be spent on=20
subtasks of the project. While this is only preliminary, you will be=20
required to provide a detailed plan latest at the beginning of GSoC and=
=20
during the project you will issue weekly progress reports against that =
plan.

According to my knowledge the preliminary schedule will be as follows.

Week 1: Understanding the netfilter implementation thoroughly and=20
getting acquainted with the code base and build system. Devote time to=20
understand work done until now towards performance improvement and=20
design decisions thus taken.

Week 2: Setup environment to measure performance and profile netfilter=20
code, understand the metric involved, establish benchmarks.

Week 3-8 : Research alternatives for packet classification code.=20
Implement them, profile the modified code. Conclude and again think for=
=20
improvements.

Week 9 and 10: Testing and bugfixing. Send out a code review request=20
(may be to the netfilter-devel list)

Week 11: Improvements & incorporating suggestions from code review.=20
Start Documentation.

Week 12: Documenting and packaging deliverables.


Additional info: 	http://www.utdallas.edu/~shreyas.bhatewara
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
